program test2
    use, intrinsic :: iso_fortran_env, only: dp => real64
    implicit none
    real(dp), parameter :: PI = acos(-1.0_dp)
    real(dp), parameter :: e = exp(1.0_dp)
    ! deklaracija spremenljivk
    real(dp), allocatable :: T_PREV(:, :) ! zacetna temperaturna porazdelitev
    real(dp), allocatable :: T(:, :) ! temperaturna porazdelitev
    real(dp) :: L ! dolzina
    real(dp) :: H ! visina
    real(dp) :: dx ! korak v x-smer mreže
    real(dp) :: dy ! korak v y-smer mreže
    real(dp) :: dt ! časovni korak
    real(dp) :: D ! koeficient toplotne difuzivnosti
    real(dp) :: c1, c2 ! konstante za lazji izracun
    real(dp) :: change ! najvecja sprememba temperature 
    real(dp) :: tol ! toleranca (za ustaljeno stanje)
    real(dp) :: error ! najvecja absolutna napaka
    real(dp) :: temp, max_temp, min_temp
    integer :: nt ! maksimalno število časovnih korakov 
    integer :: nx ! stevilo tock v x smer
    integer :: ny ! stevilo tock v y smer
    integer :: i, j, k
    integer :: steps ! stevilo korakov metode
    logical :: converged
    ! inicializacija spremenljivk
    error = 0
    converged = .false. 
    steps = 0
    L = 1 
    H = 1 
    nx = 20
    ny = 20
    dx = L / (nx - 1)
    dy = H / (ny - 1)
    allocate(T(0:ny+1, 1:nx))
    allocate(T_PREV(0:ny+1, 1:nx))
    tol = 1.0e-12_dp
    nt = 100000
    D = 1
    dt = 0.5_dp / (D * ((1.0_dp / dx ** 2) + (1.0_dp / dy ** 2))) ! iz pogoja stabilnosti
    c1 = D * dt / dx ** 2
    c2 = D * dt / dy ** 2
    T_PREV = 50.0_dp ! zacetna temperatura 
    T_PREV(:, 1) = 0.0_dp ! Dirichletov pogoj
    T_PREV(:, nx) = 0.0_dp ! Dirichletov pogoj
    do i = 2, nx
        T_PREV(1, i - 1) = 100 * sin(PI * (i - 2) * dx)
    end do 
    T = T_PREV
    
    ! preverba pogoja stabilnosti
    !if (c1 + c2 > 0.5_dp) then 
    !    error stop 'Pogoj stabilnosti ni izpolnjen!' 
    !end if

    do k = 1, nt
        do i = 2, nx - 1
            do j = 2, ny
                T(j, i) = T_PREV(j, i) + & 
                          c1 * (T_PREV(j, i + 1) - 2 * T_PREV(j, i) + T_PREV(j, i - 1)) + & 
                          c2 * (T_PREV(j + 1, i) - 2 * T_PREV(j, i) + T_PREV(j - 1, i)) 
            end do 
        end do 
        T(ny+1, :) = T(ny-1, :) ! Neumannov robni pogoj
        change = maxval(abs(T(1:ny,:) - T_PREV(1:ny, :)))
        if (change < tol) then 
            converged = .true.
            steps = k
            exit ! ustaljeno stanje
        end if
        T_PREV = T 
        ! blow up check - delete later
        max_temp = maxval(T(1:ny, :))
        min_temp = minval(T(1:ny, :))
        if (max_temp > 100) then 
            write(*, '(A, I0, A, ES12.4)') 'Blow up at ', k , 'th step with value ', max_temp
            exit 
        else if (min_temp < -1.0e-10_dp) then 
            write(*, '(A, I0, A, ES12.4)') 'Blow up at ', k , 'th step with value ', min_temp
            exit
        end if
    end do 

    do i = 1, nx
        do j = 1, ny
            temp = abs(T(j, i) - 100 * (e ** (pi * (1 - (j - 1) * dy)) + e ** (-PI * (1 - (j - 1) * dy))) / &
                   (e ** PI + e ** (-PI)) * sin(PI * (i - 1) * dx))
            if (temp > error) then 
                error = temp
            end if 
        end do 
    end do     

    if (converged) then 
        write(*, '(A, I0, A)') 'Metoda je konvergirala pri ', steps, ' korakih.'    
    else 
        write(*, '(A, I0, A)') 'Metoda je opravila maksimalno število korakov: ', nt, '.' 
    end if 

    write(*, '(A, ES12.4)') 'Največja absolutna napaka', error

    open(unit = 10, file = 'T_test2.data', status='replace')
    do j = 1, ny
        do i = 1, nx
            write(10, '(ES25.16)', advance='no') T(j, i)
        end do
        write(10, *) ! end the line
    end do 

    deallocate(T, T_PREV)
end program
