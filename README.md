# 2D enačba prenosa toplote

Reševanje dvodimenzionalne enačbe prenosa toplote

$$\frac{\partial T}{\partial t} = D \nabla^2 T$$

z metodo končnih diferenc (eksplicitna shema: prema diferenca v času, centralna v prostoru) na kvadratni domeni $L = H = 1$. Neumannovi robni pogoji so implementirani z navideznimi vozlišči. Računamo do ustaljenega stanja in rezultat primerjamo z analitično rešitvijo.

Projektna naloga iz numeričnega modeliranja, LFDT, Fakulteta za strojništvo UL.

## Testna primera

1. Levi rob $T = 100$, desni rob $T = 0$, zgornji in spodnji rob izolirana. Točna rešitev: $T = 100(1 - x)$.
2. Levi in desni rob $T = 0$, spodnji rob $T = 100\sin(\pi x)$, zgornji rob izoliran. Točna rešitev: $T = 100\,\frac{\cosh(\pi(1-y))}{\cosh \pi}\sin(\pi x)$.

## Prevajanje in zagon

```bash
gfortran -O2 test1.f90 -o test1
./test1          # zapiše T_test1.data

gfortran -O2 test2.f90 -o test2
./test2          # zapiše T_test2.data
```

## Grafi

```bash
python3 -m venv venv
source venv/bin/activate
pip install numpy matplotlib
python3 errfield2.py
```
