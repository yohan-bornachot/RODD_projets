int NbParcelles =...; //nombre de parcelles
range Parcelles =1..NbParcelles;
int T =...; //horizon de planification
range Periode=1..T;
int SURF=...;
int lmax= ...; // duree au-del� de laquelle prolonger la jach�re n'am�liore plus le rendement'
int amax= ...; //nombre max de de semestres de cultures
{int} C[1..2] = ...; //cultures en semestre pair/impair

int s[t in Periode]=(t%2==1)?1:2;

{int} Cultures=C[1] union C[2];

 int Demande[Cultures][Periode]=...;
 
 tuple sommet{
 int l; //age de la jachere
 int a; // age de la culture
 int j; //culture ou jachere en cours 
 }
 
 {sommet} Sommets=...;
 
 tuple arc {
sommet i; //extremite initiale
sommet f; //extremite finale
int rend;
}  
 
 {arc} Arcs=...;
 {arc} InitArc=
 {<<2,0,0>,<2,0,0>,0>,
 <<2,0,0>,<2,1,1>,120>
 };
 
 dvar boolean x[Arcs][Periode][Parcelles];
 
