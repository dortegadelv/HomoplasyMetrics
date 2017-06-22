#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int arg;
float theta0low,theta0up,theta1low,theta1up,exptimelow,exptimeup;
float randtheta0,randtheta1,randtime,ancientrate;
int i,seeds;
int lineal0flag,lineal1flag,linealtflag,exptflag;
float exprate;
main(argc,argv)
        int argc;
        char *argv[];
{
int howmany;

void getpars( int argc, char *argv[], int *howmany )  ;

getpars( argc, argv, &howmany);
FILE *pf, *fopen() ;
pf= fopen ("randomnumber.txt","w");

//fprintf(stderr,"0=%i	1=%i	t=%i\n",lineal0flag ,lineal1flag, linealtflag);
/*printf("%f	%f\n",theta0low,theta0up);
printf("%f	%f\n",theta1low,theta1up);
printf("%f	%f\n",exptimelow,exptimeup);*/
srand(seeds);
printf("%i",seeds);
for(i=0;i<howmany;i++){

if(lineal0flag == 1){
randtheta0 =((theta0up-theta0low) *((float) rand() / (float) 0x7fffffff)) + theta0low;
}
if(lineal1flag == 1){
randtheta1 =((theta1up-theta1low) *((float) rand() / (float) 0x7fffffff)) + theta1low;}
if(linealtflag == 1){
randtime =((exptimeup-exptimelow) *((float) rand() / (float) 0x7fffffff)) + exptimelow;}
else if (exptflag ==1){randtime = (-log(((float) rand() / (float) 0x7fffffff)))/exprate;}
fprintf(pf,"%f	%f	%f\n",randtime, randtheta0, randtheta1);
}
}

void
getpars(int argc, char *argv[], int *phowmany )
{

if( argc < 2 ){ fprintf(stderr,"Too few command line arguments\n");
usage();
}
void argcheck( int arg, int argc, char ** ), commandlineseed( char ** ) ;
*phowmany = atoi( argv[1] );
if( *phowmany  <= 0 ) { fprintf(stderr,"Second argument error. howmany <= 0. \n");
usage();
}
arg = 2;
while( arg < argc ){
		if( argv[arg][0] != '-' ) { fprintf(stderr," argument should be -%s ?\n", argv[arg]); usage();}
		switch ( argv[arg][1] ){

		case 'y' :
			arg++;
			exptflag = 1;
			exprate = atof (argv[arg++] );
			//fprintf(stderr,"t=%i ",linealtflag);
			break;
			case '0' :
			arg++;
			argcheck( arg, argc, argv);
			theta0low = atof (argv[arg++] );
			theta0up = atof (argv[arg++] );
			lineal0flag = 1;
			//printf("%f	%f\n",theta0low,theta0up);
			break;
			case '1' :
			arg++;
			argcheck( arg, argc, argv);
			theta1low = atof (argv[arg++] );
			theta1up = atof (argv[arg++] );
			lineal1flag = 1;
			//printf("%f	%f\n",theta1low,theta1up);
			break;
			case 't' :
			arg++;
			argcheck( arg, argc, argv);
			exptimelow = atof (argv[arg++] );
			exptimeup = atof (argv[arg++] );
			linealtflag = 1;
			//printf("%f	%f\n",exptimelow,exptimeup);
			break;
			case 'r' :
			arg++;
			argcheck( arg, argc, argv);
			seeds = atof (argv[arg++] );
			
			//printf("%i\n",seeds);
			break;

			}
}
}

	int
usage()
{
fprintf(stderr,"usage: randnumb howmany \n");
/*howmany tells us how many series of repetitions of random numbers we must obtain*/
fprintf(stderr,"Options: \n"); 
fprintf(stderr,"-0 tells us the value of theta before the expansion. Theta0 = 2*N0*u\n");
fprintf(stderr,"-1 tells us the value of theta after the expansion. Theta1 = 2*N1*u\n");
fprintf(stderr,"-t tau, the time of expansion\n");
exit(1);
}

	void
argcheck( int arg, int argc, char *argv[] )
{
	if( (arg >= argc ) || ( argv[arg][0] == '-') ) {
	   fprintf(stderr,"not enough arguments after %s\n", argv[arg-1] ) ;

	   exit(0);
	  }
}
