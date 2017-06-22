/* compile with gcc -o msHOT msGCHOT.c streecGCHOT.c rand1.c -lm */
/*same as ms.c but with mutliple crossover and geneconv hotspots addition */

/***** ms.c     ************************************************
*
*       Generates samples of gametes ( theta given or fixed number 
*						of segregating sites.)
*	Usage is shown by typing ms without arguments.   
        usage: ms nsam howmany  -t  theta  [options]
		or
	       ms nsam howmany -s segsites  [options] 

	   nsam is the number of gametes per sample.
	   howmany is the number of samples to produce.
	   With -t the numbers of segregating sites will randomly vary 
		from one sample to the next.
	   with -s segsites,  the number of segregating sites will be
		segsites in each sample.

           Other options: See msdoc.pdf or after downloading and compiling, type ms<CR>.


*	  Arguments of the options are explained here:

           npop:  Number of subpopulations which make up the total population
           ni:  the sample size from the i th subpopulation (all must be 
		specified.) The output will have the gametes in order such that
		the first n1 gametes are from the first island, the next n2 are
		from the second island, etc.
           nsites: number of sites between which recombination can occur.
           theta: 4No times the neutral mutation rate 
           rho: recombination rate between ends of segment times 4No
	   f: ratio of conversion rate to recombination rate. (Wiuf and Hein model.)
	   track_len:  mean length of conversion track in units of sites.  The 
		       total number of sites is nsites, specified with the -r option.
           mig_rate: migration rate: the fraction of each subpop made up of
                 migrants times 4No. 
           howmany: howmany samples to generate.

	Note:  In the above definition, No is the total diploid population if
		npop is one, otherwise, No is the diploid population size of each
		subpopulation. 
	A seed file called "seedms" will be created  if it doesn't exist. The
		seed(s) in this file will be modified by the program. 
		So subsequent runs
		will produce new output.  The initial contents of seedms will be
		printed on the second line of the output.
        Output consists of one line with the command line arguments and one
	 	line with the seed(s).
		The samples appear sequentially following that line.
		Each sample begins with "//", then the number of segregating sites, the positions
		of the segregating sites (on a scale of 0.0 - 1.0). On the following
		lines are the sampled gametes, with mutants alleles represented as
		ones and ancestral alleles as zeros.
	To compile:  cc -o ms  ms.c  streec.c  rand1.c -lm
		or:  cc -o ms ms.c streec.c rand2.c -lm
	 (Of course, gcc would be used instead of cc on some machines.  And -O3 or 
		some other optimization switches might be usefully employed with some 
		compilers.) ( rand1.c uses drand48(), whereas rand2.c uses rand() ).

*
*   Modifications made to combine ms and mss on 25 Feb 2001
*	Modifications to command line options to use switches  25 Feb 2001
*	Modifications to add // before each sample  25 Feb 2001
	Modifications to add gene conversion 5 Mar 2001
	Added demographic options -d  13 Mar 2001
	Changed ran1() to use rand(). Changed seed i/o to accomodate this change. 20 April.
	Changed cleftr() to check for zero rand() .13 June 2001
	Move seed stuff to subroutine seedit()  11 July 2001
	Modified streec.c to handle zero length demographic intervals 9 Aug 2001
	Corrected problem with negative growth rates (Thanks to D. Posada and C. Wiuf) 13 May 2002
	Changed sample_stats.c to output thetah - pi rather than pi - thetah.  March 8 2003.
	Changed many command line options, allowing arbitrary migration matrix, and subpopulation
	   sizes.  Also allows parameters to come from a file. Option to output trees.  Option to
	   split and join subpopulations.   March 8, 2003. (Old versions saved in msold.tar ).
	!!! Fixed bug in -en option.  Earlier versions may have produced garbage when -en ... used. 9 Dec 2003
	Fixed bug which resulted in incorrect results for the case where
             rho = 0.0 and gene conversion rate > 0.0. This case was not handled
	    correctly in early versions of the program. 5 Apr 2004.  (Thanks to
	    Vincent Plagnol for pointing out this problem.) 
	Fixed bug in prtree().  Earlier versions may have produced garbage when the -T option was used.
		 1 Jul 2004.
	Fixed bug in -e. options that caused problems with -f option  13 Aug 2004.
	Fixed bug in -es option, which was a problem when used with -eG. (Thanks again to V. Plagnol.) 6 Nov. 2004
	Added -F option:  -F minfreq  produces output with sites with minor allele freq < minfreq filtered out.  11 Nov. 2004.
	Fixed bug in streec.c (isseg() ).  Bug caused segmentation fault, crash on some machines. (Thanks
	    to Melissa Jane Todd-Hubisz for finding and reporting this bug.)
	Added -seeds option 4 Nov 2006
	Added "tbs" arguments feature 4 Nov 2006
***************************************************************************/


#define UN_EXTERN
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <string.h>
#include "ms.h"
#include "eca_funcsHOTmulti.h"

#define SITESINC 10 

unsigned maxsites = SITESINC ;

struct node{
	int abv;
	int ndes;
	float time;
	};

struct segl {
	int beg;
	struct node *ptree;
	int next;
	};

double *posit ;
double segfac ;
int count, ntbs ;
struct params pars ;
/*I have added some functions and an structure*/	
struct rejection_statistics rs;
	double nucdiv(int, int, int **);
	double tajd(int, int, double) ;
	double hfay(int, int, char **);
	double thetah(int, int, char **);
	double a1f(int);
double a2f(int);
double b1f(int);
double b2f(int);
double c1f(double, double);
double c2f(int, double, double, double);
double e1f(double, double);
double e2f(double, double, double);
	
main(argc,argv)
        int argc;
        char *argv[];
{
	int i, k, howmany, segsites ;
	char **list, **cmatrix(), **tbsparamstrs ;
	FILE *pf, *fopen() ;
	double probss ;
	void seedit( const char * ) ;
	void getpars( int argc, char *argv[], int *howmany )  ;
	int gensam( char **list, double *probss ) ;
	void argcheck( int arg, int argc, char ** ), commandlineseed( char ** ) ;

/*I will add this function*/
double ran1();
float heterozygosis(int **, int, int);
float variancemean (int **, int, int);
int numberofconfigurations(int **, int, int);
float Fst (int**, int, int, int, int *);
float sizehomoplasyloc (int **, int, int, char***);
float ISmicHeterozygosis (int **, int, int, char***);
float SMMmichomoplasyloc (int **, int, int, char***);
float ISdist (int **, int, int, char***);
float SMMdist (int **, int, int, char***);
float IS_P (int **, int, int, char***);
float SMM_P (int **, int, int, char***);
float SMMmichomoplasyloc (int **, int, int, char***);
float SH (int **, int , int , char ***);
float MASH (int **, int, int);
float SASH (int **, int , int , char ***);
float SHchanges(int **, int , int , char ***);
float SHdistance (int **, int , int , char ***);
float HomoBC(int **, int , int , char ***);
int sitesSMM (int **, int , int );
int singleton (int **, int , int );
float msitesvar(int **, int , int);
float hetero(int **, int , int) ;
float configmicmean (int **, int , int);
int numberofconfigurationsIS(char ***, int, int );
	/*i will add this variable*/
	int j,l,m,n,counter, arg, npop;
	int s, co1, co2, tbsnumber, cr;
	tbsnumber = 0;
	double pi, theta0, theta1, time, migr, division;
	rs.simulationnumber = 0;
	FILE *inf;
	int simnum=0;

/*I add this piece of code*/
	ntbs = 0 ;   /* these next few lines are for reading in parameters from a file (for each sample) */
	tbsparamstrs = (char **)malloc( argc*sizeof(char *) ) ;

	/*for( i=0; i<argc; i++) printf("%s ",argv[i]);*/
	for( i =0; i<argc; i++) tbsparamstrs[i] = (char *)malloc(30*sizeof(char) ) ;
	for( i = 1; i<argc ; i++)
			if( strcmp( argv[i],"tbs") == 0 )  argv[i] = tbsparamstrs[ ntbs++] ;
	
	count=0;

	if( ntbs > 0 )  for( k=0; k<ntbs; k++)  scanf(" %s", tbsparamstrs[k] );
	getpars( argc, argv, &howmany) ;   /* results are stored in global variable, pars */
	

	if( !pars.commandlineseedflag ) seedit( "s");
	pf = stdout ;

	if( pars.mp.segsitesin ==  0 ) {
	     list = cmatrix(pars.cp.nsam,maxsites+1);
	     posit = (double *)malloc( (unsigned)( maxsites*sizeof( double)) ) ;
	}
	else {
	     list = cmatrix(pars.cp.nsam, pars.mp.segsitesin+1 ) ;
	     posit = (double *)malloc( (unsigned)( pars.mp.segsitesin*sizeof( double)) ) ;
	     if( pars.mp.theta > 0.0 ){
		    segfac = 1.0 ;
		    for(  i= pars.mp.segsitesin; i > 1; i--) segfac *= i ;
		 }
	}

    while( howmany-count++ ) {
	   if( (ntbs > 0) && (count >1 ) ){
	         for( k=0; k<ntbs; k++){ 
			    if( scanf(" %s", tbsparamstrs[k]) == EOF ){
			       if( !pars.commandlineseedflag ) seedit( "end" );
				   exit(0);
				}
			 }
			 getpars( argc, argv, &howmany) ;
			 //theta = theta + theta*((rs.micronumber-1)/(rs.micronumber));
			 	
		

	   }
	/*One line to adjust for theta in the microsatellites*/
		
	/*End of my line to adjust for theta*/
       //fprintf(pf,"\n//");
	   if( ntbs >0 ){
			for(k=0; k< 3; k++){//printf("%s\t", tbsparamstrs[k] ) ;
			} 
		}
	
		//printf("\n");
        segsites = gensam( list, &probss ) ; 
        if( (segsites > 0 ) || ( pars.mp.theta > 0.0 ) ) {
          //fprintf(pf,"segsites: %d\n",segsites);
	       if( (pars.mp.segsitesin > 0 ) && ( pars.mp.theta > 0.0 )) 
		  //     fprintf(pf,"\nprob: %g", probss ) ;
		   if( segsites > 0 ){}	//fprintf(pf,"\npositions: ");
		  for( i=0; i<segsites; i++){
		//printf("%6.4lf ",posit[i] );
		  }
              rs.segsites = segsites;
           //fprintf(pf,"\n");
		   			  //fprintf(pf,"Mis sitios\n");
	       if( segsites > 0 ) 
	          for(i=0;i<pars.cp.nsam; i++) { //fprintf(pf,"%s\n", list[i] ); 
			  /*Aqui voy a ver sí puedo ver cada casilla de los caracteres de la matriz que me indican los sitios segregantes*/

			  for(k=0;k<segsites;k++){
			 // printf("%c",list[i][k]);
			  }
			 //
			  
			//  printf("\n");
			  }
	    }
		if(rs.rejectionflag==1){
		simnum++;
		rs.hcounter=1;
		rs.simulationnumber++;
		rs.simnum= malloc(30*sizeof(char));
		sprintf(rs.simnum, "%i.txt", rs.simulationnumber);
		pf=fopen(rs.simnum,"w");
		
		
		rs.microsegsite = malloc(segsites*sizeof(int));
		rs.microsize = malloc(pars.cp.nsam*sizeof(int*));
		for(i=0;i<pars.cp.nsam;i++){
		*(rs.microsize +i) = malloc(rs.micronumber*sizeof(int));
		}
		rs.infinitesitepart = malloc(pars.cp.nsam*sizeof(char**));
		for(i=0;i<pars.cp.nsam;i++){
		*(rs.infinitesitepart + i) = malloc(rs.micronumber*sizeof(char*));
		}
		for(i=0;i<pars.cp.nsam;i++){
		for(j=0;j<rs.micronumber;j++){
		*(*(rs.infinitesitepart + i)+j) = malloc(segsites*sizeof(char));
		strcpy( *(*(rs.infinitesitepart + i)+j), "");
		}}
	//	printf("%s\t",tbsparamstrs[0]);
		//printf("Numero de micros = %i\n", rs.micronumber);
		rs.fractionsites = 1.0/pars.cp.nsites;
		rs.sitebeginning = 0.0;
		rs.sitethreshold = 2.0/ pars.cp.nsites;
		//printf("Site threshold = %6.4lf, pars.cp.nsites = %i", rs.sitethreshold ,pars.cp.nsites);
		for (i=0; i<segsites; i++){
		
		rs.randomnumber = ran1();
		if(rs.randomnumber <= 0.5){
		*(rs.microsegsite+i) = -1;
		}else{
		*(rs.microsegsite+i) = 1;
		}
		}
		/*printf("Mi matriz de sitios segregantes\n");
		 for(i=0;i<pars.cp.nsam; i++) { 
			  for(k=0;k<segsites;k++){}
			  printf("%c",list[i][k]);
			  
			  printf("\n");
			  }
		*/
		//printf("Micro seg sites\n");
		/*for (i=0;i<segsites;i++){
		printf("%i ",*(rs.microsegsite+i));
		}*/
		for(i=0;i<rs.micronumber;i++){
		for(k=0;k<pars.cp.nsam;k++){
		*(*(rs.microsize +k)+i) = 0;
		}
		}
		//printf("sitebeginning = %f, sitethreshold = %f va\n", rs.sitebeginning, rs.sitethreshold);
		int initialflag = 0;
		int finalflag = 0;
		int micronumber = 0;
		int *number;
		int *number2;
		char *segvalue;
		char *segvalue2;
		number = malloc (1*sizeof(int));
		number2 = malloc (1*sizeof(int));
		segvalue = malloc (1*sizeof(char));
		segvalue2 = malloc (1*sizeof(char));
		for(j=0;j<pars.cp.nsam;j++){
		for(k=0;k<segsites;k++){
		//printf("1sitebeginning = %f, sitethreshold = %f posit[k] = %f\n", rs.sitebeginning, rs.sitethreshold, posit[k]);
		//printf("sitio aumenta o decrementa %i\n",*(rs.microsegsite+k));
	
		
		//printf("list: %c\n",list[j][k]);
		
		if(rs.sitebeginning ==0){initialflag =1;}
		
		if((initialflag ==0) && (finalflag ==0)){
		if(posit[k]>rs.sitebeginning && posit[k]< rs.sitethreshold){
	
	//printf("micro!: %f micronumber = %i\n",posit[k], micronumber);
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	} else{strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	}else if (posit[k]<=(rs.sitebeginning + (4*rs.fractionsites))){
	//printf("entre sitio: %f\n",posit[k]);
	}
	 else{
	while(posit[k]> (rs.sitebeginning + (4*rs.fractionsites)) ){
	rs.sitebeginning = rs.sitebeginning + (4*rs.fractionsites);
	rs.sitethreshold = rs.sitethreshold + (4*rs.fractionsites);
	initialflag =0;
	micronumber ++;
	
	if(rs.sitethreshold ==1.0){finalflag =1;
	//printf("microweird!: %f micronumber = %i\n",posit[k], micronumber);
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	break;
	}
	else if(posit[k]>rs.sitebeginning && posit[k]< rs.sitethreshold){
	//printf("micro!: %f micronumber = %i\n",posit[k],micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	break;
	}
	}
	if (posit[k]>= rs.sitethreshold){
	//printf("entre sitio: %f\n",posit[k]);
	}	
	}
}else if (initialflag == 1){
if(posit[k]>=rs.sitebeginning && posit[k]< rs.sitethreshold){
	//printf("micro!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	}else if (posit[k]<=(rs.sitebeginning + (4*rs.fractionsites))){
	//printf("entre sitio: %f\n",posit[k]);
	}
	 else{
	while(posit[k]> (rs.sitebeginning + (4*rs.fractionsites)) ){
	rs.sitebeginning = rs.sitebeginning + (4*rs.fractionsites);
	rs.sitethreshold = rs.sitethreshold + (4*rs.fractionsites);
	micronumber++;
	initialflag =0;
	if(rs.sitethreshold ==1.0){finalflag =1;
	//printf("microweird!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	}
	else if(posit[k]>rs.sitebeginning && posit[k]< rs.sitethreshold){
	//printf("micro!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	break;
	}
	}
	if (posit[k]>= rs.sitethreshold){
	//printf("entre sitio: %f\n",posit[k]);
	}	
	}
}else if (finalflag ==1){
if(posit[k]>rs.sitebeginning && posit[k]<= rs.sitethreshold){
	//printf("micro!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	 strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	}else if (posit[k]<=(rs.sitebeginning + (4*rs.fractionsites))){
	//printf("entre sitio: %f\n",posit[k]);
	}
	 else{
	while(posit[k]> (rs.sitebeginning + (4*rs.fractionsites)) ){
	rs.sitebeginning = rs.sitebeginning + (4*rs.fractionsites);
	rs.sitethreshold = rs.sitethreshold + (4*rs.fractionsites);
	micronumber ++;
	initialflag =0;
	if(rs.sitethreshold ==1.0){finalflag =1;
	//printf("microweird!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	
	}
	else if(posit[k]>rs.sitebeginning && posit[k]< rs.sitethreshold){
	//printf("micro!: %f micronumber = %i\n",posit[k], micronumber);
	
	sprintf(segvalue,"%c" ,list[j][k]);
	*number = atoi(segvalue);
	if(*number ==1){
	if(*(rs.microsegsite + k) ==1){*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) + 1; 
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	else if (*(rs.microsegsite + k) == -1){	*(*(rs.microsize + j) +micronumber) = *(*(rs.microsize + j) +micronumber) - 1;
	strcat(*(*(rs.infinitesitepart+j)+micronumber),"1");}
	}else{ strcat(*(*(rs.infinitesitepart+j)+micronumber),"0");}
	
	break;
	}
	}
	if (posit[k]>= rs.sitethreshold){
	//printf("entre sitio: %f\n",posit[k]);
	}	
	}
}


}
rs.sitebeginning = 0.0;
rs.sitethreshold = 2.0/ pars.cp.nsites;
micronumber = 0;
initialflag = 1;
finalflag = 0;

	//printf(" initial flag %i final flag %i\n",initialflag , finalflag);
	}

	
	//printf("2sitebeginning = %f, sitethreshold = %f posit[k] = %f\n", rs.sitebeginning, rs.sitethreshold, posit[k]);
	rs.flagbegin=0;
//printf ("Tamano de microsatelites\n");

for(k=0;k<rs.micronumber;k++){
//printf("\t%i",k);
}
//printf("Micros\n");
//printf("micro = %i\n",rs.micronumber);
		for(k=0;k<pars.cp.nsam;k++){
	//	printf ("%i",k);
for(i=0;i<rs.micronumber;i++){


		if (i<rs.micronumber-1){
	fprintf (pf,"%i	",*(*(rs.microsize +k)+i));}else{
	fprintf (pf,"%i",*(*(rs.microsize +k)+i));
	}
		}
		fprintf (pf,"\n");
		}

fclose(pf);

 rs.sizehomoplasy1 = sizehomoplasyloc (rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.SH = SH(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.MASH = MASH(rs.microsize, rs.micronumber, pars.cp.nsam);
rs.SASH = SASH(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);

rs.SHchanges = SHchanges(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.SHdist = SHdistance(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.HBC = HomoBC(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.rejectionvariance = variancemean(rs.microsize, rs.micronumber, pars.cp.nsam);
rs.heterozygosismean = heterozygosis(rs.microsize, rs.micronumber, pars.cp.nsam);
rs.numberconfigurations = numberofconfigurations(rs.microsize, rs.micronumber, pars.cp.nsam);

/*Check parts of the homoplasy statistics*/

rs.TempISMic = ISmicHeterozygosis(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.TempSMMMic = SMMmichomoplasyloc(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.TempISDist = ISdist(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.TempSMMDist = SMMdist(rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.TempPIS = IS_P (rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);
rs.TempPSMM = SMM_P (rs.microsize, rs.micronumber, pars.cp.nsam,rs.infinitesitepart);


/*End of check*/
			
rs.pi = nucdiv(pars.cp.nsam, rs.micronumber, rs.microsize) ;
rs.simsites = sitesSMM(rs.microsize,rs.micronumber,pars.cp.nsam) ;
rs.simsingleton = singleton(rs.microsize,rs.micronumber,pars.cp.nsam) ;
rs.simmicsegsites = msitesvar(rs.microsize,rs.micronumber,pars.cp.nsam) ;
rs.simheterohap = hetero(rs.microsize,rs.micronumber,pars.cp.nsam) ;
rs.simconfigmicvar = configmicmean(rs.microsize,rs.micronumber,pars.cp.nsam) ;
//fprintf(stderr,"%i\n",rs.simsingleton);
//fprintf(stderr,"varsim = %f data = %f\n",rs.simconfigmicvar, rs.dataconfigmicvar);

sprintf(rs.simnum, "%ihomoplasy.txt", rs.simulationnumber);
		pf=fopen(rs.simnum,"w");
fprintf(pf, "Sizehomoplasyloc	SH	MASH	SASH	SHchanges	SHdist	HBC");
fprintf(pf,"	Variance	Heterozygosis	Numberofconfig	Pi	Sites	");
fprintf(pf,"Singleton	Micsitesvar	Heteromean	configmicvar	TMRCA	");
fprintf(pf,"ISMic	SMMMic	ISDist	SMMDist	P_IS	P_SMM\n");
fprintf(pf, "%f	%f	%f	%f	%f	%f	%f",rs.sizehomoplasy1, rs.SH, rs.MASH, rs.SASH, rs.SHchanges, rs.SHdist,rs.HBC);
fprintf(pf, "	%f	%f	%i	%f	%i",rs.rejectionvariance, rs.heterozygosismean, rs.numberconfigurations, rs.pi, rs.simsites);
fprintf(pf, "	%i	%f	%f	%f	%f	",rs.simsingleton, rs.simmicsegsites, rs.simheterohap, rs.simconfigmicvar,rs.TMRCA);
fprintf(pf, "%f	%f	%f	%f	%f	%f\n",rs.TempISMic,rs.TempSMMMic,rs.TempISDist,rs.TempSMMDist,rs.TempPIS,rs.TempPSMM);
fclose(pf);
		sprintf(rs.simnum, "infinite%i.txt", rs.simulationnumber);
		inf=fopen(rs.simnum,"w");
for(k=0;k<pars.cp.nsam;k++){
for(i=0;i<rs.micronumber;i++){
if (i<rs.micronumber-1){
if((strcmp(*(*(rs.infinitesitepart+k)+i),""))==0){fprintf (inf,"N	");}else{
	fprintf (inf,"%s	",*(*(rs.infinitesitepart+k)+i));}}else{ 
	if((strcmp(*(*(rs.infinitesitepart+k)+i),""))==0){fprintf (inf,"N");}else{
	fprintf (inf,"%s",*(*(rs.infinitesitepart +k)+i));}}
	}
	fprintf (inf,"\n");
}


		fclose(inf);
rs.datanumberofconfig = numberofconfigurations(rs.microsize, rs.micronumber, pars.cp.nsam);
		sprintf(rs.simnum, "%i.arp", rs.simulationnumber);
		pf=fopen(rs.simnum,"w");
fprintf (pf,"[Profile]\n");
fprintf (pf,"Title=\"A small example of microsatellite data\"\n");
fprintf (pf,"NbSamples=1\n");
fprintf (pf,"GenotypicData=0\n");
fprintf (pf,"GameticPhase=1\n");
fprintf (pf,"DataType=RFLP\n");
fprintf (pf,"LocusSeparator=WHITESPACE\n");
fprintf (pf,"[Data]\n");
fprintf (pf,"[[Samples]]\n");
fprintf (pf,"SampleName=\"Tus muestras\"\n");
fprintf (pf,"SampleSize=%i\n",pars.cp.nsam);
fprintf (pf,"SampleData=	{\n");
for (i=0; i<rs.datanumberofconfig; i ++){
fprintf (pf,"Hap%i	",i);
fprintf (pf,"%i	",*(rs.hapnumber + i));
for(j=0;j<rs.micronumber;j++){
rs.segsitedif = *(rs.micromaxsize + j )- *(rs.microminsize + j );


for (l=0;l<*(*(rs.microsize + *(rs.configs + i))+j) - *(rs.microminsize + j );l++){
fprintf (pf,"1");
}
for (l=*(*(rs.microsize + *(rs.configs + i))+j) - *(rs.microminsize + j );l<rs.segsitedif;l++){
fprintf(pf,"0");
}

}
fprintf (pf,"\n");
}
fprintf (pf,"} \n");

fclose(pf);


//free(rs.configs);
rs.datanumberofconfig = numberofconfigurationsIS(rs.infinitesitepart, rs.micronumber, pars.cp.nsam);
		sprintf(rs.simnum, "%i_infinite.arp", rs.simulationnumber);
		pf=fopen(rs.simnum,"w");
fprintf (pf,"[Profile]\n");
fprintf (pf,"Title=\"A small example of microsatellite data\"\n");
fprintf (pf,"NbSamples=1\n");
fprintf (pf,"GenotypicData=0\n");
fprintf (pf,"GameticPhase=1\n");
fprintf (pf,"DataType=RFLP\n");
fprintf (pf,"LocusSeparator=WHITESPACE\n");
fprintf (pf,"[Data]\n");
fprintf (pf,"[[Samples]]\n");
fprintf (pf,"SampleName=\"Tus muestras\"\n");
fprintf (pf,"SampleSize=%i\n",pars.cp.nsam);
fprintf (pf,"SampleData=	{\n");
for (i=0; i<rs.datanumberofconfig; i ++){
fprintf (pf,"Hap%i	",i);
fprintf (pf,"%i	",*(rs.hapnumber + i));
for(j=0;j<rs.micronumber;j++){
rs.segsitedif = *(rs.micromaxsize + j )- *(rs.microminsize + j );



fprintf (pf,"%s",*(*(rs.infinitesitepart + *(rs.configs + i))+j));

}
fprintf (pf,"\n");
}
fprintf (pf,"} \n");

fclose(pf);
free(rs.hapnumber);
free(rs.configs);
for(i=0;i<pars.cp.nsam;i++){
		free(*(rs.microsize +i));
		}
		free(rs.microsize);
for(i=0;i<pars.cp.nsam;i++){
		for(j=0;j<rs.micronumber;j++){
		
		free( *(*(rs.infinitesitepart + i)+j));
		}}
		for(i=0;i<pars.cp.nsam;i++){
		free(*(rs.infinitesitepart + i));
		}
		free(rs.infinitesitepart);
		free(rs.simnum);

free(rs.microminsize);
free(rs.micromaxsize);
free(rs.microsegsite);
free(number);

		free(number2);
		free(segvalue);
		free(segvalue2);
if( ( simnum % 10 ) == 0) {
      fprintf(stderr,"simnum = %i\n",simnum);}
		}
		}




		//printf("\nTajima´s D: %f",tajd(pars.cp.nsam,segsites,pi));
	if( !pars.commandlineseedflag ) seedit( "end" );

}



	int 
gensam( char **list, double *pprobss ) 
{
	int nsegs, h, i, k, j, seg, ns, start, end, len, segsit ;
	struct segl *seglst, *segtre_mig(struct c_params *p, int *nsegs ) ; /* used to be: [MAXSEG];  */
	double nsinv,  tseg, tt, ttime(struct node *, int nsam), ttimemf(struct node *, int nsam, int mfreq), division ;
	double *pk;
	int *ss;
	int segsitesin,nsites;
	double theta, es ;
	int nsam, mfreq ;
	void prtree( struct node *ptree, int nsam);
	int make_gametes(int nsam, int mfreq,  struct node *ptree, double tt, int newsites, int ns, char **list );
 	void ndes_setup( struct node *, int nsam );

	//printf("1nsites=%i",pars.cp.nsites);
	nsites = pars.cp.nsites ;
	nsinv = 1./nsites;

	/*Ver cómo funciona esto*/
	//printf("sitios %f\n",nsinv);
	seglst = segtre_mig(&(pars.cp),  &nsegs ) ;
	
	nsam = pars.cp.nsam;
	segsitesin = pars.mp.segsitesin ;
	
	/*One line to adjust for theta in the microsatellites*/
	division =(float)pars.mp.theta*(((float)rs.micronumber-1)/((float)rs.micronumber));
	//printf ("Tus micros = %i y division %f",rs.micronumber, division);
	
	theta = pars.mp.theta + division;
	/*End of my line to adjust for theta*/
	mfreq = pars.mp.mfreq ;

	if( pars.mp.treeflag ) {
	
	  	ns = 0 ;
	    for( seg=0, k=0; k<nsegs; seg=seglst[seg].next, k++) {
	      if( (pars.cp.r > 0.0 ) || (pars.cp.f > 0.0) ){
		     end = ( k<nsegs-1 ? seglst[seglst[seg].next].beg -1 : nsites-1 );
		     start = seglst[seg].beg ;
		     len = end - start + 1 ;
		    printf("[%d]", len);
			//printf("nsites=%i",nsites);
	      }
	      prtree( seglst[seg].ptree, nsam ) ;
	      if( (segsitesin == 0) && ( theta == 0.0 ) ) 
	  	      free(seglst[seg].ptree) ;
	    }
	}

    if( (segsitesin == 0) && ( theta > 0.0)   ) {
	  ns = 0 ;
	  for( seg=0, k=0; k<nsegs; seg=seglst[seg].next, k++) { 
		if( mfreq > 1 ) ndes_setup( seglst[seg].ptree, nsam );
		end = ( k<nsegs-1 ? seglst[seglst[seg].next].beg -1 : nsites-1 );
		start = seglst[seg].beg ;
		//printf("start %i y end %i\n",start,end);
		len = end - start + 1 ;
		//printf ("theta = %f\n",theta);
		tseg = len*(theta/nsites) ;
			//printf("nsites=%i",nsites);
		//	printf("[%d]", nsites);
		if( mfreq == 1) tt = ttime(seglst[seg].ptree, nsam);
                else tt = ttimemf(seglst[seg].ptree, nsam, mfreq );
		segsit = poisso( tseg*tt );
		if( (segsit + ns) >= maxsites ) {
			maxsites = segsit + ns + SITESINC ;
			posit = (double *)realloc(posit, maxsites*sizeof(double) ) ;
			  biggerlist(nsam, list) ; 
		}
		make_gametes(nsam,mfreq,seglst[seg].ptree,tt, segsit, ns, list );
		free(seglst[seg].ptree) ;
		locate(segsit,start*nsinv, len*nsinv,posit+ns);   
		ns += segsit;
	  }
    } /*Mi desmadre*/
	else if ((segsitesin == 0) && ( rs.variablethetaflag == 1)){
	 float startmicro = 0;
	 float endmicro = 1;
	 int thetacounter = 0;
	 ns = 0 ;
	// printf ("follow me down\n");
	  for( seg=0, k=0; k<nsegs; seg=seglst[seg].next, k++) { 
		if( mfreq > 1 ) ndes_setup( seglst[seg].ptree, nsam );
		end = ( k<nsegs-1 ? seglst[seglst[seg].next].beg -1 : nsites-1 );
		start = seglst[seg].beg ;
		//printf("start %i y end %i\n",start,end);
		//printf("To the valley below\n");
		while ((startmicro >=start) && (endmicro <=end)){
		if (endmicro == (pars.cp.nsites-1)){
		//printf("enter");
		tseg = *(rs.thetavalues + thetacounter) ;
		if( mfreq == 1) tt = ttime(seglst[seg].ptree, nsam);
                else tt = ttimemf(seglst[seg].ptree, nsam, mfreq );
		segsit = poisso( tseg*tt );
		//printf ("Segsit = %i",segsit);
		if( (segsit + ns) >= maxsites ) {
			maxsites = segsit + ns + SITESINC ;
			posit = (double *)realloc(posit, maxsites*sizeof(double) ) ;
			  biggerlist(nsam, list) ; 
		}
		make_gametes(nsam,mfreq,seglst[seg].ptree,tt, segsit, ns, list );
		
		locate(segsit,startmicro*nsinv, 2*nsinv,posit+ns);   
		ns += segsit;
	//printf ("theta counter1 = %i, startm = %f, endm = %f, start = %i, end = %i, tseg = %f\n",thetacounter,startmicro,endmicro,start,end,*(rs.thetavalues + thetacounter));
		thetacounter++;
		startmicro = startmicro + 4;
		endmicro = endmicro + 4;
		
	  } else{
	 // printf("enter");
	  tseg = 2* *(rs.thetavalues + thetacounter) ;
	  if( mfreq == 1) tt = ttime(seglst[seg].ptree, nsam);
                else tt = ttimemf(seglst[seg].ptree, nsam, mfreq );
		segsit = poisso( tseg*tt );
		//printf ("Segsit = %i",segsit);
		if( (segsit + ns) >= maxsites ) {
			maxsites = segsit + ns + SITESINC ;
			posit = (double *)realloc(posit, maxsites*sizeof(double) ) ;
			  biggerlist(nsam, list) ; 
		}
		make_gametes(nsam,mfreq,seglst[seg].ptree,tt, segsit, ns, list );
		
		locate(segsit,startmicro*nsinv, 4*nsinv,posit+ns);
		ns += segsit;
	//printf ("theta counter2 = %i, startm = %f, endm = %f, start = %i, end = %i, tseg = %f\n",thetacounter,startmicro,endmicro,start,end,*(rs.thetavalues + thetacounter));
	  thetacounter++;
	  startmicro = startmicro + 4;
		endmicro = endmicro + 4;
		
	  }
	  
	  }
	  free(seglst[seg].ptree);
	  }
	  }
	/*Fin de mi desmadre*/
   else if( segsitesin > 0 ) {

        pk = (double *)malloc((unsigned)(nsegs*sizeof(double)));
        ss = (int *)malloc((unsigned)(nsegs*sizeof(int)));
        if( (pk==NULL) || (ss==NULL) ) perror("malloc error. gensam.2");


	  tt = 0.0 ;
	  for( seg=0, k=0; k<nsegs; seg=seglst[seg].next, k++) { 
		if( mfreq > 1 ) ndes_setup( seglst[seg].ptree, nsam );
		end = ( k<nsegs-1 ? seglst[seglst[seg].next].beg -1 : nsites-1 );
		start = seglst[seg].beg ;
		len = end - start + 1 ;
		tseg = len/(double)nsites ;
               if( mfreq == 1 ) pk[k] = ttime(seglst[seg].ptree,nsam)*tseg ;
               else pk[k] = ttimemf(seglst[seg].ptree,nsam, mfreq)*tseg ;
                 tt += pk[k] ;
	  }
	  if( theta > 0.0 ) { 
	    es = theta * tt ;
	    *pprobss = exp( -es )*pow( es, (double) segsitesin) / segfac ;
	  }
	  if( tt > 0.0 ) {
          for (k=0;k<nsegs;k++) pk[k] /= tt ;
          mnmial(segsitesin,nsegs,pk,ss);
	  }
	  else
            for( k=0; k<nsegs; k++) ss[k] = 0 ;
	  ns = 0 ;
	  for( seg=0, k=0; k<nsegs; seg=seglst[seg].next, k++) { 
		 end = ( k<nsegs-1 ? seglst[seglst[seg].next].beg -1 : nsites-1 );
		 start = seglst[seg].beg ;
		 len = end - start + 1 ;
		 tseg = len/(double)nsites;
		 make_gametes(nsam,mfreq,seglst[seg].ptree,tt*pk[k]/tseg, ss[k], ns, list);

		 free(seglst[seg].ptree) ;
		 locate(ss[k],start*nsinv, len*nsinv,posit+ns);   
		 ns += ss[k] ;
	  }
	  free(pk);
	  free(ss);

    }
	for(i=0;i<nsam;i++) list[i][ns] = '\0' ;
	return( ns ) ;
}

	void 
ndes_setup(struct node *ptree, int nsam )
{
	int i ;

	for( i=0; i<nsam; i++) (ptree+i)->ndes = 1 ;
	for( i = nsam; i< 2*nsam -1; i++) (ptree+i)->ndes = 0 ;
	for( i= 0; i< 2*nsam -2 ; i++)  (ptree+((ptree+i)->abv))->ndes += (ptree+i)->ndes ;

}

	int
biggerlist(nsam,  list )
	int nsam ;
	char ** list ;
{
	int i;

/*  fprintf(stderr,"maxsites: %d\n",maxsites);  */	
	for( i=0; i<nsam; i++){
	   list[i] = (char *)realloc( list[i],maxsites*sizeof(char) ) ;
	   if( list[i] == NULL ) perror( "realloc error. bigger");
	   }
}
	   


/* allocates space for gametes (character strings) */
	char **
cmatrix(nsam,len)
	int nsam, len;
{
	int i;
	char **m;

	if( ! ( m = (char **) malloc( (unsigned) nsam*sizeof( char* ) ) ) )
	   perror("alloc error in cmatrix") ;
	for( i=0; i<nsam; i++) {
		if( ! ( m[i] = (char *) malloc( (unsigned) len*sizeof( char ) )))
			perror("alloc error in cmatric. 2");
		}
	return( m );
}



	int
locate(n,beg,len,ptr)
	int n;
	double beg, len, *ptr;
{
	int i;

	ordran(n,ptr);
	for(i=0; i<n; i++)
		ptr[i] = beg + ptr[i]*len ;
		/*Agregue estoprintf("%f ",ptr[i]);*/

/*Y esto*/ //printf("va\n");
}


  void
getpars(int argc, char *argv[], int *phowmany )
{
	int arg, i, j, sum , pop , argstart, npop , npop2, pop2 ;
	double migr, mij, psize, palpha ;
	//struct params p;
	void addtoelist( struct devent *pt, struct devent *elist ); 
	void argcheck( int arg, int argc, char ** ), commandlineseed( char ** ) ;
	void free_eventlist( struct devent *pt, int npop );
	struct devent *ptemp , *pt ;
	FILE *pf ;
	char ch3 ;
	

  if( count == 0 ) {
	if( argc < 4 ){ fprintf(stderr,"Too few command line arguments\n"); usage();}
	pars.cp.nsam = atoi( argv[1] );
	if( pars.cp.nsam <= 0 ) { fprintf(stderr,"First argument error. nsam <= 0. \n"); usage();}
	*phowmany = atoi( argv[2] );
	if( *phowmany  <= 0 ) { fprintf(stderr,"Second argument error. howmany <= 0. \n"); usage();}
	pars.commandlineseedflag = 0 ;
	pars.cp.r = pars.mp.theta =  pars.cp.f = 0.0 ;
	pars.cp.track_len = 0. ;
	pars.cp.npop = npop = 1 ;
	pars.cp.mig_mat = (double **)malloc( (unsigned) sizeof( double *) );
	pars.cp.mig_mat[0] = (double *)malloc( (unsigned)sizeof(double *));
	pars.cp.mig_mat[0][0] =  0.0 ;
	pars.mp.segsitesin = 0 ;
	pars.mp.treeflag = 0 ;
        pars.mp.mfreq = 1 ;
	pars.cp.config = (int *) malloc( (unsigned)(( pars.cp.npop +1 ) *sizeof( int)) );
	(pars.cp.config)[0] = pars.cp.nsam ;
	pars.cp.size= (double *) malloc( (unsigned)( pars.cp.npop *sizeof( double )) );
	(pars.cp.size)[0] = 1.0  ;
	pars.cp.alphag = (double *) malloc( (unsigned)(( pars.cp.npop ) *sizeof( double )) );
	(pars.cp.alphag)[0] = 0.0  ;
	pars.cp.nsites = 2 ;
  }
  else{
	npop = pars.cp.npop ;
	free_eventlist( pars.cp.deventlist, npop );
  }
  	pars.cp.deventlist = NULL ;

	/*  Eric's stuff for hotspots and ascertainment -- initializations */
	gNumHotSpots = 0;
	//gHotSpots = NULL;
	//gHSRates = NULL;
	gHSRates = NULL;
	gHotSpotStart = NULL;
	gHotSpotEnd = NULL;

	gNumHotSpotsGC = 0;
	gHSRatesGC = NULL;
	gHotSpotStartGC = NULL;
	gHotSpotEndGC = NULL;
	rs.variablethetaflag=0;
	arg = 3 ;

	while( arg < argc ){
	//printf(" Tu cadenita %c", argv[arg][0]);
		if( argv[arg][0] != '-' ) { fprintf(stderr," argument should be -%s ?\n", argv[arg]); usage();}
		switch ( argv[arg][1] ){
			case 'f' :
				if( ntbs > 0 ) { fprintf(stderr," can't use tbs args and -f option.\n"); exit(1); }
				arg++;
				argcheck( arg, argc, argv);
				pf = fopen( argv[arg], "r" ) ;
				if( pf == NULL ) {fprintf(stderr," no parameter file %s\n", argv[arg] ); exit(0);}
				arg++;
				argc++ ;
				argv = (char **)malloc(  (unsigned)(argc+1)*sizeof( char *) ) ;
				argv[arg] = (char *)malloc( (unsigned)(20*sizeof( char )) ) ;
				argstart = arg ;
				while( fscanf(pf," %s", argv[arg]) != EOF ) {
					arg++;
					argc++;
					argv = (char **)realloc( argv, (unsigned)argc*sizeof( char*) ) ;
				        argv[arg] = (char *)malloc( (unsigned)(20*sizeof( char )) ) ;
					}
				fclose(pf);
				argc--;
				arg = argstart ;
				break;
			case 'Q' :
				rs.rejectionflag = 1 ;
				arg++;
				break;
				/*My piece of code*/
			case 'W' :
			arg++;
			argcheck( arg, argc, argv);
			rs.thetavaluesnum = atoi(  argv[arg++] );
			rs.thetavalues = (float *)malloc (rs.thetavaluesnum*sizeof(float));
			for (i=0;i<rs.thetavaluesnum;i++){
			argcheck( arg, argc, argv);
			*(rs.thetavalues+i) = atof (argv[arg++] );
			}
			rs.variablethetaflag =1;
				break;
			case 'z' : 
			arg++;
				argcheck( arg, argc, argv);
				pars.cp.r = 0;
			pars.cp.nsites = atoi( argv[arg++]);
			rs.micronumber = pars.cp.nsites;
			pars.cp.nsites = pars.cp.nsites*2 + (pars.cp.nsites - 1)*2;
			if( pars.cp.nsites <1 ){
					fprintf(stderr,"with -z option must specify both rec_rate and nsites>1\n");
					usage();
					}
					//printf("numero de microsatelites = %i\n",rs.micronumber);
					
					/*End of my part of the code*/
			break;
				case 'a' : 
			arg++;
				argcheck( arg, argc, argv);
				rs.alpha = atoi( argv[arg++]);
				break;
				case 'A' : 
			arg++;
				argcheck( arg, argc, argv);
				rs.readacceptances = atoi( argv[arg++]);
				break;
				/*End of my piece of code*/
			case 'r' : 
				arg++;
				argcheck( arg, argc, argv);
				pars.cp.r = atof(  argv[arg++] );
				//argcheck( arg, argc, argv);
				if( pars.cp.nsites <1 ){
					fprintf(stderr,"with -r option must specify rec_rate\n");
					usage();
					}
				break;
			case 'c' : 
				arg++;
				argcheck( arg, argc, argv);
				pars.cp.f = atof(  argv[arg++] );
				argcheck( arg, argc, argv);
				pars.cp.track_len = atof( argv[arg++]);
				if( pars.cp.track_len <1. ){
					fprintf(stderr,"with -c option must specify both f and track_len>0\n");
					usage();
					}
				break;		
			case 't' : 
				arg++;
				argcheck( arg, argc, argv);
				pars.mp.theta = atof(  argv[arg++] );
			
				break;
			case 's' : 
				arg++;
				argcheck( arg, argc, argv);
				if( argv[arg-1][2] == 'e' ){  /* command line seeds */
					pars.commandlineseedflag = 1 ;
					if( count == 0 ) commandlineseed(argv+arg );
					arg += 3 ;
				}
				else {
				    pars.mp.segsitesin = atoi(  argv[arg++] );
				}
				break;
			case 'F' : 
				arg++;
				argcheck( arg, argc, argv);
				pars.mp.mfreq = atoi(  argv[arg++] );
                                if( (pars.mp.mfreq < 2 ) || (pars.mp.mfreq > pars.cp.nsam/2 ) ){
                                    fprintf(stderr," mfreq must be >= 2 and <= nsam/2.\n");
                                    usage();
                                    }
				break;
			case 'T' : 
				pars.mp.treeflag = 1 ;
				arg++;
				break;
			case 'I' : 
				arg++;
			    if( count == 0 ) {
				    argcheck( arg, argc, argv);
					pars.cp.npop = atoi( argv[arg]);
			        pars.cp.config = (int *) realloc( pars.cp.config, (unsigned)( pars.cp.npop*sizeof( int)));
				    npop = pars.cp.npop ;
				}
			    arg++;
				for( i=0; i< pars.cp.npop; i++) {
				   argcheck( arg, argc, argv);
				   pars.cp.config[i] = atoi( argv[arg++]);
				   }
				if( count == 0 ){
				   pars.cp.mig_mat = (double **)realloc(pars.cp.mig_mat, (unsigned)(pars.cp.npop*sizeof(double *) )) ;
				   for(i=0; i<pars.cp.npop; i++) pars.cp.mig_mat[i] = (double *)realloc(pars.cp.mig_mat[i],
					   (unsigned)( pars.cp.npop*sizeof(double)));
				   pars.cp.size = (double *) realloc( pars.cp.size, (unsigned)( pars.cp.npop*sizeof( double )));
				   pars.cp.alphag = (double *) realloc( pars.cp.alphag, (unsigned)( pars.cp.npop*sizeof( double )));
				}
				for( i=1; i< pars.cp.npop ; i++) {
					 (pars.cp.size)[i] = (pars.cp.size)[0]  ;
					(pars.cp.alphag)[i] = (pars.cp.alphag)[0] ;
				}
				if( (arg <argc) && ( argv[arg][0] != '-' ) ) {
				  argcheck( arg, argc, argv);
				  migr = atof(  argv[arg++] );
				}
				else migr = 0.0 ;
				for( i=0; i<pars.cp.npop; i++) 
				    for( j=0; j<pars.cp.npop; j++) pars.cp.mig_mat[i][j] = migr/(pars.cp.npop-1) ;
				for( i=0; i< pars.cp.npop; i++) pars.cp.mig_mat[i][i] = migr ;
				break;
			case 'm' :
			     if( npop < 2 ) { fprintf(stderr,"Must use -I option first.\n"); usage();}
			     if( argv[arg][2] == 'a' ) {
				    arg++;
				    for( pop = 0; pop <npop; pop++)
				      for( pop2 = 0; pop2 <npop; pop2++){
					     argcheck( arg, argc, argv);
					     pars.cp.mig_mat[pop][pop2]= atof( argv[arg++] ) ;
					  }
				    for( pop = 0; pop < npop; pop++) {
					  pars.cp.mig_mat[pop][pop] = 0.0 ;
					  for( pop2 = 0; pop2 < npop; pop2++){
					    if( pop2 != pop ) pars.cp.mig_mat[pop][pop] += pars.cp.mig_mat[pop][pop2] ;
					  }
				    }	
				}
			    else {
		             arg++;
			         argcheck( arg, argc, argv);
		             i = atoi( argv[arg++] ) -1;
			         argcheck( arg, argc, argv);
		             j = atoi( argv[arg++] ) -1;
			         argcheck( arg, argc, argv);
		             mij = atof( argv[arg++] );
		             pars.cp.mig_mat[i][i] += mij -  pars.cp.mig_mat[i][j]  ;
		             pars.cp.mig_mat[i][j] = mij;
			    }
				break;
			case 'v' :  /* case added by Eric Anderson to allow specification of recombinational
							hotspots of different intensities  */
				arg++;
			        argcheck( arg, argc, argv);
				gNumHotSpots = atoi(argv[arg++]);
				gHotSpotStart = (int *)calloc((size_t)gNumHotSpots, sizeof(int));
				gHotSpotEnd = (int *)calloc((size_t)gNumHotSpots, sizeof(int));
				gHSRates = (double *)calloc((size_t)gNumHotSpots, sizeof(double));

				for (i = 0; i<gNumHotSpots; i++)
				  {
				    argcheck( arg, argc, argv);
				    gHotSpotStart[i] = atoi(argv[arg++]);
				    gHotSpotStart[i] = gHotSpotStart[i]-1;
				    argcheck( arg, argc, argv);
				    gHotSpotEnd[i] = atoi(argv[arg++]);
				    gHotSpotEnd[i] = gHotSpotEnd[i]-1;
				    argcheck( arg, argc, argv);
				    gHSRates[i] = atof(argv[arg++]);
				    //printf("\n\n%d\n\n",p.cp.nsites);
				    if ((gHotSpotStart[i] < 0) || (gHotSpotEnd[i] >= pars.cp.nsites))
			             {
				        fprintf(stderr,"\n\n At least one crossover hotspot is not contained within the sequence. Exiting....\n\n");
					usage();
				     }
				    if(i>0 && gHotSpotStart[i]<=gHotSpotEnd[i-1])  
				      {
					fprintf(stderr,"\n\nHot spots overlapping or not listed in order.  Abort!...\n\n");
					usage();
				      }
				    if(gHotSpotStart[i] >= gHotSpotEnd[i])
				      {
					fprintf(stderr,"\n\nHotspot locations entered incorrectly.\n\n");
				 	usage();
                                      }
				  }
				break;
			case 'V' :  /* case added by GRH to allow specification of a single gene conversion hotspot of specified intensity in specified area*/
				arg++;
			        argcheck( arg, argc, argv);
				gNumHotSpotsGC = atoi(argv[arg++]);
				gHotSpotStartGC = (int *)calloc((size_t)gNumHotSpotsGC, sizeof(int));
				gHotSpotEndGC = (int *)calloc((size_t)gNumHotSpotsGC, sizeof(int));
				gHSRatesGC = (double *)calloc((size_t)gNumHotSpotsGC, sizeof(double));

				for (i = 0; i<gNumHotSpotsGC; i++)
				  {
			            argcheck( arg, argc, argv);
				    gHotSpotStartGC[i] = atoi(argv[arg++]);
				    gHotSpotStartGC[i] = gHotSpotStartGC[i]-1;
			            argcheck( arg, argc, argv);
				    gHotSpotEndGC[i] = atoi(argv[arg++]);
				    gHotSpotEndGC[i] = gHotSpotEndGC[i]-1;
			            argcheck( arg, argc, argv);
				    gHSRatesGC[i] = atof(argv[arg++]);
                                    if ((gHotSpotStartGC[i] < 0) || (gHotSpotEndGC[i] >= pars.cp.nsites))
			             { 
                                       fprintf(stderr,"\n\n At least one gene conversion hotspot is not contained within the sequence. Exiting....\n\n");
  	                               usage();
                                     }
				    if(i>0 && gHotSpotStartGC[i]<=gHotSpotEndGC[i-1])  
				      {
					fprintf(stderr,"\n\nGene Conv Hot spots overlapping or not listed in order.  Abort!...\n\n");
					usage();
				      }
                                    if(gHotSpotStartGC[i] >= gHotSpotEndGC[i])
                                      {
                                        fprintf(stderr,"\n\nHotspot locations entered incorrectly.\n\n");
					usage();
                                      }
				  }
				break;
			case 'n' :
			     if( npop < 2 ) { fprintf(stderr,"Must use -I option first.\n"); usage();}
			    arg++;
			    argcheck( arg, argc, argv);
			    pop = atoi( argv[arg++] ) -1;
			    argcheck( arg, argc, argv);
			    psize = atof( argv[arg++] );
			    pars.cp.size[pop] = psize ;
			   break;
			case 'g' :
			     if( npop < 2 ) { fprintf(stderr,"Must use -I option first.\n"); usage();}
			    arg++;
			    argcheck( arg, argc, argv);
			    pop = atoi( argv[arg++] ) -1;
			    if( arg >= argc ) { fprintf(stderr,"Not enough arg's after -G.\n"); usage(); }
			    palpha = atof( argv[arg++] );
			    pars.cp.alphag[pop] = palpha ;
			   break;
			case 'G' :
			    arg++;
			    if( arg >= argc ) { fprintf(stderr,"Not enough arg's after -G.\n"); usage(); }
			    palpha = atof( argv[arg++] );
			    for( i=0; i<pars.cp.npop; i++) 
			       pars.cp.alphag[i] = palpha ;
			   break;
			case 'e' :
			    pt = (struct devent *)malloc( sizeof( struct devent) ) ;
			    pt->detype = argv[arg][2] ;
			    ch3 = argv[arg][3] ;
			    arg++;
			    argcheck( arg, argc, argv);
			    pt->time = atof( argv[arg++] ) ;
			    pt->nextde = NULL ;
			    if( pars.cp.deventlist == NULL ) 
				    pars.cp.deventlist = pt ;
			    else if ( pt->time < pars.cp.deventlist->time ) { 
				    ptemp = pars.cp.deventlist ;
				    pars.cp.deventlist = pt ;
				    pt->nextde = ptemp ;	
				}	
			    else
				   addtoelist( pt, pars.cp.deventlist ) ;
			    switch( pt->detype ) {
				case 'N' :
			          argcheck( arg, argc, argv);
				      pt->paramv = atof( argv[arg++] ) ;
				      break;
				case 'G' :
				  if( arg >= argc ) { fprintf(stderr,"Not enough arg's after -eG.\n"); usage(); }
				  pt->paramv = atof( argv[arg++] ) ;
				  break;
				case 'M' :
				    argcheck( arg, argc, argv);
				    pt->paramv = atof( argv[arg++] ) ;
				    break;
				case 'n' :
			          argcheck( arg, argc, argv);
				  pt->popi = atoi( argv[arg++] ) -1 ;
			          argcheck( arg, argc, argv);
				  pt->paramv = atof( argv[arg++] ) ;
				  break;
				case 'g' :
			          argcheck( arg, argc, argv);
				  pt->popi = atoi( argv[arg++] ) -1 ;
				  if( arg >= argc ) { fprintf(stderr,"Not enough arg's after -eg.\n"); usage(); }
				  pt->paramv = atof( argv[arg++] ) ;
				  break;
				case 's' :
			          argcheck( arg, argc, argv);
				  pt->popi = atoi( argv[arg++] ) -1 ;
			          argcheck( arg, argc, argv);
				  pt->paramv = atof( argv[arg++] ) ;
				  break;
				case 'm' :
				  if( ch3 == 'a' ) {
				     pt->detype = 'a' ;
					 argcheck( arg, argc, argv);
				     npop2 = atoi( argv[arg++] ) ;
				     pt->mat = (double **)malloc( (unsigned)npop2*sizeof( double *) ) ;
				     for( pop =0; pop <npop2; pop++){
					   (pt->mat)[pop] = (double *)malloc( (unsigned)npop2*sizeof( double) );
					   for( i=0; i<npop2; i++){
					     if( i == pop ) arg++;
					     else {
				           argcheck( arg, argc, argv); 
					       (pt->mat)[pop][i] = atof( argv[arg++] ) ;
					     }
					   }
				     }
				     for( pop = 0; pop < npop2; pop++) {
					    (pt->mat)[pop][pop] = 0.0 ;
					    for( pop2 = 0; pop2 < npop2; pop2++){
					       if( pop2 != pop ) (pt->mat)[pop][pop] += (pt->mat)[pop][pop2] ;
					    }
				     }	
				  }
				  else {
			            argcheck( arg, argc, argv);
				        pt->popi = atoi( argv[arg++] ) -1 ;
			            argcheck( arg, argc, argv);
				        pt->popj = atoi( argv[arg++] ) -1 ;
			            argcheck( arg, argc, argv);
				        pt->paramv = atof( argv[arg++] ) ;
				  }
				  break;
				case 'j' :
			          argcheck( arg, argc, argv);
				  pt->popi = atoi( argv[arg++] ) -1 ;
			          argcheck( arg, argc, argv);
				  pt->popj = atoi( argv[arg++] ) -1 ;
				  break;
				default: fprintf(stderr,"e event\n");  usage();
			    }
			 break;
			default: fprintf(stderr," option default\n");  usage() ;
			}
		}
		/*I add something at the end*/
		if( (pars.mp.theta == 0.0) && ( pars.mp.segsitesin == 0 ) && ( pars.mp.treeflag == 0 ) && (rs.variablethetaflag == 0) ) {
			fprintf(stderr," either -s or -t or -T option must be used. \n");
			usage();
			exit(1);
			}
		sum = 0 ;
		for( i=0; i< pars.cp.npop; i++) sum += (pars.cp.config)[i] ;
		if( sum != pars.cp.nsam ) {
			fprintf(stderr," sum sample sizes != nsam\n");
			usage();
			exit(1);
			}
}


	void
argcheck( int arg, int argc, char *argv[] )
{
	if( (arg >= argc ) || ( argv[arg][0] == '-') ) {
	   fprintf(stderr,"not enough arguments after %s\n", argv[arg-1] ) ;
	   fprintf(stderr,"For usage type: ms<return>\n");
	   exit(0);
	  }
}
	
	int
usage()
{
fprintf(stderr,"usage: ms nsam howmany \n");
fprintf(stderr,"  Options: \n"); 
fprintf(stderr,"\t -t theta   (this option and/or the next must be used. Theta = 4*N0*u )\n");
fprintf(stderr,"\t -s segsites   ( fixed number of segregating sites)\n");
fprintf(stderr,"\t -T          (Output gene tree.)\n");
fprintf(stderr,"\t -F minfreq     Output only sites with freq of minor allele >= minfreq.\n");
fprintf(stderr,"\t -r rho nsites     (rho here is 4Nc)\n");
fprintf(stderr,"\t\t -c f track_len   (f = ratio of conversion rate to rec rate. tracklen is mean length.) \n");
fprintf(stderr,"\t\t\t if rho = 0.,  f = 4*N0*g, with g the gene conversion rate.\n"); 
fprintf(stderr,"\t -G alpha  ( N(t) = N0*exp(-alpha*t) .  alpha = -log(Np/Nr)/t\n");      
fprintf(stderr,"\t -I npop n1 n2 ... [mig_rate] (all elements of mig matrix set to mig_rate/(npop-1) \n");    
fprintf(stderr,"\t\t -m i j m_ij    (i,j-th element of mig matrix set to m_ij.)\n"); 
fprintf(stderr,"\t\t -ma m_11 m_12 m_13 m_21 m_22 m_23 ...(Assign values to elements of migration matrix.)\n"); 
fprintf(stderr,"\t\t -n i size_i   (popi has size set to size_i*N0 \n");
fprintf(stderr,"\t\t -g i alpha_i  (If used must appear after -M option.)\n"); 
fprintf(stderr,"\t   The following options modify parameters at the time 't' specified as the first argument:\n");
fprintf(stderr,"\t -eG t alpha  (Modify growth rate of all pop's.)\n");     
fprintf(stderr,"\t -eg t i alpha_i  (Modify growth rate of pop i.) \n");    
fprintf(stderr,"\t -eM t mig_rate   (Modify the mig matrix so all elements are mig_rate/(npop-1)\n"); 
fprintf(stderr,"\t -em t i j m_ij    (i,j-th element of mig matrix set to m_ij at time t )\n"); 
fprintf(stderr,"\t -ema t npop  m_11 m_12 m_13 m_21 m_22 m_23 ...(Assign values to elements of migration matrix.)\n");  
fprintf(stderr,"\t -eN t size  (Modify pop sizes. New sizes = size*N0 ) \n");    
fprintf(stderr,"\t -en t i size_i  (Modify pop size of pop i.  New size of popi = size_i*N0 .)\n");
fprintf(stderr,"\t -es t i proportion  (Split: pop i -> pop-i + pop-npop, npop increases by 1.\n");    
fprintf(stderr,"\t\t proportion is probability that each lineage stays in pop-i. (p, 1-p are admixt. proport.\n");
fprintf(stderr,"\t\t Size of pop npop is set to N0 and alpha = 0.0 , size and alpha of pop i are unchanged.\n");
fprintf(stderr,"\t -ej t i j   ( Join lineages in pop i and pop j into pop j\n");
fprintf(stderr,"\t\t  size, alpha and M are unchanged.\n");  
fprintf(stderr,"\t -v J a_1 b_1 I_1 ... a_J b_J I_J  ( Incorporate J crossover hotspots, each of intensity I_j on [a_j,b_j] )\n");
fprintf(stderr,"\t -V K a_1 b_1 I_1 ... a_K b_K I_K  ( Incorporate K gene conversion hotspots, each of intensity I_k on [a_k,b_k] )\n");
fprintf(stderr,"\t  -f filename     ( Read command line arguments from file filename.)\n");  
fprintf(stderr," See msdoc.pdf for explanation of these parameters.\n");

exit(1);
}
	void
addtoelist( struct devent *pt, struct devent *elist ) 
{
	struct devent *plast, *pevent, *ptemp  ;

	pevent = elist ;
	while(  (pevent != NULL ) && ( pevent->time <= pt->time ) )  {
		plast = pevent ;
		pevent = pevent->nextde ;
		}
	ptemp = plast->nextde ;
	plast->nextde = pt ;
	pt->nextde = ptemp ;
}

	void 
free_eventlist( struct devent *pt, int npop )
{
   struct devent *next ;
   int pop ;
   
   while( pt != NULL){
	  next = pt->nextde ;
	  if( pt->detype == 'a' ) {
	     for( pop = 0; pop < npop; pop++) free( (pt->mat)[pop] );
		 free( pt->mat );
	  }
	  free(pt);
	  pt = next ;
   }
}

	
/************ make_gametes.c  *******************************************
*
*
*****************************************************************************/

#define STATE1 '1'
#define STATE2 '0'

	int
make_gametes(int nsam, int mfreq, struct node *ptree, double tt, int newsites, int ns, char **list )
{
	int  tip, j,  node ;
        int pickb(int nsam, struct node *ptree, double tt), 
            pickbmf(int nsam, int mfreq, struct node *ptree, double tt) ;

	for(  j=ns; j< ns+newsites ;  j++ ) {
		if( mfreq == 1 ) node = pickb(  nsam, ptree, tt);
		else node = pickbmf(  nsam, mfreq, ptree, tt);
		for( tip=0; tip < nsam ; tip++) {
		   if( tdesn(ptree, tip, node) ) list[tip][j] = STATE1 ;
		   else list[tip][j] = STATE2 ;
		   }
		}
}


/***  ttime.c : Returns the total time in the tree, *ptree, with nsam tips. **/

	double
ttime( ptree, nsam)
	struct node *ptree;
	int nsam;
{
	double t;
	int i;

	t = (ptree + 2*nsam-2) -> time ;
	for( i=nsam; i< 2*nsam-1 ; i++)
		t += (ptree + i)-> time ;
	return(t);
}


	double
ttimemf( ptree, nsam, mfreq)
	struct node *ptree;
	int nsam, mfreq;
{
	double t;
	int i;

	t = 0. ;
	for( i=0;  i< 2*nsam-2  ; i++)
	  if( ( (ptree+i)->ndes >= mfreq )  && ( (ptree+i)->ndes <= nsam-mfreq) )
		t += (ptree + (ptree+i)->abv )->time - (ptree+i)->time ;
	return(t);
}


	void
prtree( ptree, nsam)
	struct node *ptree;
	int nsam;
{
	double t;
	int i, *descl, *descr ;
	void parens( struct node *ptree, int *descl, int *descr, int noden );

	descl = (int *)malloc( (unsigned)(2*nsam-1)*sizeof( int) );
	descr = (int *)malloc( (unsigned)(2*nsam-1)*sizeof( int) );
	for( i=0; i<2*nsam-1; i++) descl[i] = descr[i] = -1 ;
	for( i = 0; i< 2*nsam-2; i++){
	  if( descl[ (ptree+i)->abv ] == -1 ) descl[(ptree+i)->abv] = i ;
	  else descr[ (ptree+i)->abv] = i ;
	 }
	parens( ptree, descl, descr, 2*nsam-2);
	free( descl ) ;
	free( descr ) ;
}

	void
parens( struct node *ptree, int *descl, int *descr,  int noden)
{
	double time ;

   if( descl[noden] == -1 ) {
	printf("%d:%5.3lf", noden+1, (ptree+ ((ptree+noden)->abv))->time );
	}
   else{
	printf("(");
	parens( ptree, descl,descr, descl[noden] ) ;
	printf(",");
	parens(ptree, descl, descr, descr[noden] ) ;
	if( (ptree+noden)->abv == 0 ){printf(");\n"); } 
	else {
	  time = (ptree + (ptree+noden)->abv )->time - (ptree+noden)->time ;
	  printf("):%5.3lf", time );
	  }
        }
}

/***  pickb : returns a random branch from the tree. The probability of picking
              a particular branch is proportional to its duration. tt is total
	      time in tree.   ****/

	int
pickb(nsam, ptree, tt)
	int nsam;
	struct node *ptree;
	double tt;
{
	double x, y, ran1();
	int i;

	x = ran1()*tt;
	for( i=0, y=0; i < 2*nsam-2 ; i++) {
		y += (ptree + (ptree+i)->abv )->time - (ptree+i)->time ;
		if( y >= x ) return( i ) ;
		}
	return( i );
}

	int
pickbmf(nsam, mfreq, ptree, tt )
	int nsam, mfreq;
	struct node *ptree;
	double tt;
{
	double x, y, ran1();
	int i;

	x = ran1()*tt;
	for( i=0, y=0; i < 2*nsam-2 ; i++) {
	  if( ( (ptree+i)->ndes >= mfreq )  && ( (ptree+i)->ndes <= nsam-mfreq) )
		y += (ptree + (ptree+i)->abv )->time - (ptree+i)->time ;
	  if( y >= x ) return( i ) ;
	}
	return( i );
}

/****  tdesn : returns 1 if tip is a descendant of node in *ptree, otherwise 0. **/

	int
tdesn(ptree, tip, node )
	struct node *ptree;
	int tip, node;
{
	int k;

	for( k= tip ; k < node ; k = (ptree+k)->abv ) ;
	if( k==node ) return(1);
	else return(0);
}


/* pick2()  */

	int
pick2(n,i,j)
	int n, *i, *j;
{
	double ran1();

	*i = n * ran1() ;
	while( ( *j = n * ran1() ) == *i )
		;
	return(0) ;
}

/**** ordran.c  ***/

	int
ordran(n,pbuf)
	int n;
	double pbuf[];
{
	ranvec(n,pbuf);
	order(n,pbuf);
	return;
}


	int
mnmial(n,nclass,p,rv)
	int n, nclass, rv[];
	double p[];
{
	double ran1();
	double x, s;
	int i, j;

	for(i=0; i<nclass; i++) rv[i]=0;
	for(i=0; i<n ; i++) {
	   x = ran1();
	   j=0;
	   s = p[0];
	   while( (x > s) && ( j<(nclass-1) ) )  s += p[++j];
	   rv[j]++;
	   }
	return(j);
}

        int
order(n,pbuf)
        int n;
        double pbuf[];
{
        int gap, i, j;
        double temp;

        for( gap= n/2; gap>0; gap /= 2)
           for( i=gap; i<n; i++)
                for( j=i-gap; j>=0 && pbuf[j]>pbuf[j+gap]; j -=gap) {
                   temp = pbuf[j];
                   pbuf[j] = pbuf[j+gap];
                   pbuf[j+gap] = temp;
                   }
}


	int
ranvec(n,pbuf)
	int n;
	double pbuf[];
{
	int i;
	double ran1();

	for(i=0; i<n; i++)
		pbuf[i] = ran1();

	return;
}



	int
poisso(u)
	double u;
{
	double  cump, ru, ran1(), p, gasdev() ;
	int i=1;

	if( u > 30. ) return( (int)(0.5 + gasdev(u,u)) );
	ru = ran1();
	p = exp(-u);
	if( ru < p) return(0);
	cump = p;
	
	while( ru > ( cump += (p *= u/i ) ) )
		i++;
	return(i);
}


/* a slight modification of crecipes version */

double gasdev(m,v)
	double m, v;
{
	static int iset=0;
	static float gset;
	float fac,r,v1,v2;
	double ran1();

	if  (iset == 0) {
		do {
			v1=2.0*ran1()-1.0;
			v2=2.0*ran1()-1.0;
			r=v1*v1+v2*v2;
		} while (r >= 1.0);
		fac=sqrt(-2.0*log(r)/r);
		gset= v1*fac;
		iset=1;
		return( m + sqrt(v)*v2*fac);
	} else {
		iset=0;
		return( m + sqrt(v)*gset ) ;
	}
}

/*I have added this functions*/
	double
tajd(int nsam, int segsites, double sumk)
{

double  a1, a2, b1, b2, c1, c2, e1, e2; 
 
if( segsites == 0 ) return( 0.0) ;

a1 = a1f(nsam);
a2 = a2f(nsam);
b1 = b1f(nsam);
b2 = b2f(nsam);
c1 = c1f(a1, b1);
c2 = c2f(nsam, a1, a2, b2);
e1 = e1f(a1, c1);
e2 = e2f(a1, a2, c2);

return( (sumk - (segsites/a1))/sqrt((e1*segsites) + ((e2*segsites)*(segsites
-1))) ) ;

}

double a1f(int nsam)
{
double a1;
int i;
a1 = 0.0;
for (i=1; i<=nsam-1; i++) a1 += 1.0/i;
return (a1);
}


double a2f(int nsam) 
{
double a2;
int i;
a2 = 0.0;
for (i=1; i<=nsam-1; i++) a2 += 1.0/(i*i);
return (a2);
}


double b1f(int nsam)
{
double b1;
b1 = (nsam + 1.0)/(3.0*(nsam-1.0));
return (b1);
}


double b2f(int nsam)
{
double b2;
b2 = (2*(nsam*nsam + nsam + 3.0))/(9*nsam*(nsam - 1));
return (b2);
}


double e1f(double a1, double c1) 
{
double e1;
e1 = c1/a1;
return (e1);
}

double e2f(double a1, double a2, double c2)
{ 
double e2;
e2 = c2/((a1*a1)+a2);
return (e2);
}


double c1f(double a1, double b1)
{
double c1;
c1 = b1 - (1/a1);
return (c1);
}


double c2f(int nsam, double a1, double a2, double b2)
{
double c2;
c2 = b2 - ((nsam+2)/(a1*nsam)) + (a2/(a1 * a1));
return (c2);
}

double
nucdiv( int nsam, int mnumber, int** list)
{
	//printf("nsam = %i	mnumber =	%i\n",nsam,mnumber);
	double pi, p1, nd, nnm1  ;
	int co1,co2,s , counter;
	pi = 0.0;
	rs.maxsize= malloc(mnumber*sizeof(int));
	rs.minsize= malloc(mnumber*sizeof(int));
	rs.segtajd =0;
	for(s = 0; s <mnumber; s++){
	*(rs.maxsize +s) = *(*( list+0)+s);
	*(rs.minsize +s) = *(*( list+0)+s);
	for (co1 =0; co1<nsam;co1++){
	if( *(*( list+co1)+s)> *(rs.maxsize +s)){
	*(rs.maxsize +s) = *(*( list+co1)+s);
	}
	if( *(*( list+co1)+s)< *(rs.minsize +s)){
	*(rs.minsize +s) = *(*( list+co1)+s);
	}
	
	for(co2 = co1;co2 <nsam ; co2++){
	if(*(*( list+co1)+s) > *(*( list+co2)+s)){
	pi = pi + (*(*( list+co1)+s) - *(*( list+co2)+s));
	} else if (*(*( list+co1)+s) < *(*( list+co2)+s)){
	pi = pi + (*(*( list+co2)+s) - *(*( list+co1)+s));
	}
	}

	}
	rs.segtajd = rs.segtajd + (*(rs.maxsize +s) - *(rs.minsize +s));
	//printf("part rs.segtajd = %i",rs.segtajd);
		//printf ("pi = %f micro = %i\n",pi,s);
	}
	free(rs.maxsize);
	free(rs.minsize);
		//printf("int = %i\n",s);
	
	//printf ("pi = %f\n",pi);
		pi = pi/((nsam*(nsam-1))/2);
		//printf ("pi = %f seg = %i\n",pi,rs.segtajd);
	return( pi ) ;
}

/*   thetah - pi   */
	double
hfay( int nsam, int segsites, char **list)
{
	int s, frequency( char, int, int, char**);
	double pi, p1, nd, nnm1  ;

	pi = 0.0 ;

	nd = nsam;
	nnm1 = nd/(nd-1.0) ;
   	for( s = 0; s <segsites; s++){
		p1 = frequency('1', s,nsam,list)/nd ;
		pi += 2.0*p1*(2.*p1 - 1.0 )*nnm1 ;
		}
	return( -pi ) ;
}

/* Fay's theta_H  */
        double
thetah( int nsam, int segsites, char **list)
{
        int s, frequency( char, int, int, char**);
        double pi, p1, nd, nnm1  ;

        pi = 0.0 ;

        nd = nsam;
        nnm1 = nd/(nd-1.0) ;
        for( s = 0; s <segsites; s++){
                p1 = frequency('1', s,nsam,list) ;
                pi += p1*p1 ; 
                }
        return( pi*2.0/( nd*(nd-1.0) )  ) ;
}


        int
frequency( char allele,int site,int nsam,  char **list)
{
        int i, count=0;
        for( i=0; i<nsam; i++) count += ( list[i][site] == allele ? 1: 0 ) ;
        return( count);
}        

	int
segsub( int nsub, int segsites, char **list )
{
	int i, count = 0 , c1 ;
	int frequency( char, int, int, char**) ;

	for(i=0; i < segsites ; i++){
	  c1 = frequency('1',i,nsub, list);
	  if( ( c1 > 0 ) && ( c1 <nsub )  ) count++;
	  }
	return( count ) ;
}
	
float heterozygosis(int **size,int mnumber, int secnumber){
int i, j, k;
rs.microflag = NULL;
rs.heterozygosis = NULL;
rs.microflag = malloc(secnumber * sizeof(int));
rs.heterozygosis = malloc(mnumber * sizeof(float));
	for (i=0;i<mnumber;i++){
	*(rs.heterozygosis + i) = 0;
	}
	rs.heterozygosismean =0;

	for (i=0;i<mnumber;i++){
	rs.counterfreq=0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if(*(*(size + k)+i)  == *(*(size + j)+i)){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}

	rs.counterfreq++;
	*(rs.heterozygosis + i) = *(rs.heterozygosis + i) + rs.homopart * rs.homopart;
	}
	
	}
	
	*(rs.heterozygosis + i) = 1- *(rs.heterozygosis + i);
	*(rs.heterozygosis + i) = ((*(rs.heterozygosis + i))/(secnumber -1))*secnumber;
	rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	}
	rs.heterozygosismean = rs.heterozygosismean/mnumber;
	free(rs.microflag);

	free(rs.heterozygosis);
	return (rs.heterozygosismean);
}
	
float variancemean (int **size,int mnumber, int secnumber){
int i, k;
rs.mean = NULL;
rs.mean = malloc (mnumber *sizeof(float));
for(i=0;i<mnumber;i++){
*(rs.mean + i) = 0;
		for(k=0;k<secnumber;k++){
		*(rs.mean + i) = *(rs.mean + i) + *(*(size +k)+i);
		}
		*(rs.mean + i) = (*(rs.mean + i))/secnumber;
		}
//printf("\nLas medias\n");
for(i=0;i<mnumber;i++){	
	
	//printf("%f ",*(rs.mean + i));
	}
rs.variance = NULL;
rs.variance = malloc(mnumber *sizeof(float));

for(i=0;i<mnumber;i++){
rs.sum = 0;
rs.squaresum = 0;

		for(k=0;k<secnumber;k++){
		rs.sum = rs.sum + *(*(size +k)+i);
		rs.squaresum = rs.squaresum + (*(*(size +k)+i) * *(*(size +k)+i));
		}
	*(rs.variance + i) = (rs.squaresum -((rs.sum*rs.sum)/secnumber))/(secnumber - 1);	
		}	
//printf("\nLas varianzas\n");
rs.rejectionvariance = 0;
		for(i=0;i<mnumber;i++){
//printf("%f ", *(rs.variance + i));
rs.rejectionvariance = *(rs.variance + i) + rs.rejectionvariance;
}	
rs.rejectionvariance = rs.rejectionvariance/mnumber;
//printf("La media de tu rejection variance %f",rs.rejectionvariance);
free(rs.mean);
free(rs.variance);
return (rs.rejectionvariance);

}
	
int numberofconfigurations(int **size, int mnumber, int secnumber){
int i, j, k, l, count, flag;
rs.microflag =malloc(secnumber * sizeof(int));
rs.configs = malloc (secnumber * sizeof (int));
l = 0;
		for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	rs.numberconfigurations = secnumber;
	
		for(i=0;i<secnumber;i++){
		if(*(rs.microflag + i) == 0){
		for(j=i+1;j<secnumber;j++){
		rs.configflag =0;
		
		for(k=0;k<mnumber;k++){
		if(*(*(size + i)+k)  != *(*(size + j)+k)){
		rs.configflag = 1;
		}
		}
		if(rs.configflag ==0){
		*(rs.microflag + j) = 1;
		rs.numberconfigurations = rs.numberconfigurations -1; 
		}
		}
		*(rs.configs + l) = i;
		l++;
		}
		}
	//	printf("\nTu número de configuraciones es %i\n",rs.numberconfigurations);
		//printf("%i\n",rs.numberconfigurations);
		for (i=0;i < rs.numberconfigurations; i ++){
	//	printf ("config num =%i	number = %i\n", i, *(rs.configs + i));
		}
rs.hapnumber = malloc (rs.numberconfigurations * sizeof (int));
for (i=0; i<rs.numberconfigurations; i ++){
count = 0;
for(j=0;j<secnumber;j++){
flag = 0;
for (k=0;k<mnumber;k++){
if (*(*(size + j)+k) != *(*(size + *(rs.configs + i))+k)){
flag = 1;
}
}
if (flag == 0){
count ++;
}
}
*(rs.hapnumber + i) = count;
//printf ("hap = %i, numero = %i\n", i, *(rs.hapnumber + i));
}
rs.microminsize = malloc (mnumber * sizeof (int) );
rs.micromaxsize = malloc (mnumber * sizeof (int) );
for (k=0;k<mnumber;k++){
*(rs.microminsize + k ) = *(*(size + 0)+k);
*(rs.micromaxsize + k ) = *(*(size + 0)+k);
for(j=0;j<secnumber;j++){
if(*(*(size + j)+k) < *(rs.microminsize + k )){
*(rs.microminsize + k ) = *(*(size + j)+k);
}
if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
*(rs.micromaxsize + k ) = *(*(size + j)+k);
}
}
//printf ("minimo = %i",*(rs.microminsize + k ));
//printf ("maximo = %i",*(rs.micromaxsize + k ));
}
free(rs.microflag);
		return (rs.numberconfigurations);
}

float Fst(int **size, int mnumber, int secnumber, int pop, int *conpop){
float totalheterozygosis, *subpopheterozygosis, subpopheterozygosisprom, Fst;
int i, j, k, l, **subpopmatrix, counterstart, counterend;
totalheterozygosis = heterozygosis(rs.datamicrosize, rs.micronumber, pars.cp.nsam);
subpopheterozygosis = malloc (pop*sizeof (float));
counterstart = 0;
for (i=0; i<pop; i++){

subpopmatrix = malloc(*(conpop + i)*sizeof(int*));
		for(j=0;j<*(conpop + i);j++){
		*(subpopmatrix +j) = malloc(mnumber*sizeof(int));
		}
counterend = counterstart + *(conpop + i);

for (j= counterstart; j< counterend; j++){
for (k=0;k<mnumber;k++){
*(*(subpopmatrix+(j-counterstart))+k) =*(*(size+j)+k); 

}

}
*(subpopheterozygosis + i ) = heterozygosis(subpopmatrix, rs.micronumber, *(conpop + i));


counterstart = counterstart + *(conpop + i);


}
subpopheterozygosisprom= 0;
for (i=0; i<pop; i++){

subpopheterozygosisprom = subpopheterozygosisprom + *(subpopheterozygosis + i );

}
subpopheterozygosisprom = subpopheterozygosisprom / pop;

Fst = (totalheterozygosis - subpopheterozygosisprom)/ totalheterozygosis;

return (Fst);
}

float sizehomoplasyloc (int **size, int mnumber, int secnumber, char ***infinite){
int i, j, k;
rs.microflag = NULL;
rs.heterozygosis = NULL;

rs.microflag = malloc(secnumber * sizeof(int));
rs.heterozygosis = malloc(mnumber * sizeof(float));
rs.infinite_heterozygosis = malloc(mnumber * sizeof(float));
rs.homoplasyloc = malloc (mnumber * sizeof (float));
	for (i=0;i<mnumber;i++){
	*(rs.heterozygosis + i) = 0;
	}
float heterozygosismean =0;
	rs.denominatorsquare = NULL;
	rs.denominatorsquare = malloc(mnumber * sizeof(float*));
	for (i=0;i<mnumber;i++){
	*(rs.denominatorsquare + i) = NULL;
	*(rs.denominatorsquare + i) = malloc(secnumber*sizeof(float));
	for (j=0;j<secnumber;j++){
	*(*(rs.denominatorsquare + i)+j) = 0;
	}
	}
	for (i=0;i<mnumber;i++){
	rs.counterfreq=0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if(*(*(size + k)+i)  == *(*(size + j)+i)){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}

	*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
	rs.counterfreq++;
	*(rs.heterozygosis + i) = *(rs.heterozygosis + i) + rs.homopart * rs.homopart;
	}
	
	}
	
	*(rs.heterozygosis + i) = 1- *(rs.heterozygosis + i);
	*(rs.heterozygosis + i) = ((*(rs.heterozygosis + i))/(secnumber -1))*secnumber;
	heterozygosismean = heterozygosismean + *(rs.heterozygosis + i);
	}
	heterozygosismean = heterozygosismean/mnumber;
	for (i=0;i<mnumber;i++){
	*(rs.infinite_heterozygosis + i) = 0;
	}
	for (i=0;i<mnumber;i++){
	for (j=0;j<secnumber;j++){
	*(*(rs.denominatorsquare + i)+j) = 0;
	}
	}
	for (i=0;i<mnumber;i++){
	rs.counterfreq=0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(*(rs.infinitesitepart + k)+i),*(*(rs.infinitesitepart + j)+i)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}

	*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
	rs.counterfreq++;
	*(rs.infinite_heterozygosis + i) = *(rs.infinite_heterozygosis + i) + rs.homopart * rs.homopart;
	}
	
	}
	
	*(rs.infinite_heterozygosis + i) = 1- *(rs.infinite_heterozygosis + i);
	*(rs.infinite_heterozygosis + i) = ((*(rs.infinite_heterozygosis + i))/(secnumber -1))*secnumber;
	//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	}
	rs.homoplasymeanloc = 0;
	for (i=0;i<mnumber;i++){
	*(rs.homoplasyloc + i) = ((1 - *(rs.infinite_heterozygosis + i))/(1-*(rs.heterozygosis + i)));
	//printf("heterozygosis = %f con micro %i\n",*(rs.infinite_heterozygosis + i), i);
	rs.homoplasymeanloc = rs.homoplasymeanloc + *(rs.homoplasyloc + i);
	}
	rs.homoplasymeanloc = 1 - rs.homoplasymeanloc/mnumber;
	free(rs.microflag);
	for (i=0;i<mnumber;i++){
	free(*(rs.denominatorsquare + i));
	}
	free(rs.denominatorsquare);
	free(rs.heterozygosis);
	free(rs.infinite_heterozygosis);
	free(rs.homoplasyloc);
	return (rs.homoplasymeanloc);
}

float SH (int **size, int mnumber, int secnumber, char ***infinite){
int i, j, k;
char *chain;
rs.microflag = NULL;

rs.microflag = malloc(secnumber * sizeof(int));
rs.microchain = malloc (secnumber*sizeof(char*));
int *compositesize;

	compositesize = malloc (secnumber*sizeof(int));
	for (i=0;i<secnumber;i++){
	*(compositesize + i) = 0;
	for (j=0;j<mnumber;j++){
	*(compositesize + i) = *(compositesize + i) + *(*(size+i)+j);
	}}
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	float MASHheterozygosis = 0;
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if(*(compositesize + j) == *(compositesize + k)){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	MASHheterozygosis = MASHheterozygosis + rs.homopart * rs.homopart;
	}
	}
	MASHheterozygosis = 1- MASHheterozygosis;
	MASHheterozygosis = ((MASHheterozygosis)/(secnumber -1))*secnumber;

	rs.ISchain = malloc(secnumber*sizeof(char*));
for (i=0;i<secnumber;i++){
	*(rs.ISchain + i) = malloc((rs.segsites*mnumber)*sizeof(char));
	strcpy(*(rs.ISchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){
	chain = malloc (rs.segsites*sizeof(char));
	sprintf(chain,"%i",*(*(infinite+i)+j));
	strcat(*(rs.ISchain + i),*(*(infinite+i)+j));
	free(chain);
	}
	}
	
float ISheterozygosis = 0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(rs.ISchain + k),*(rs.ISchain + j)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	ISheterozygosis = ISheterozygosis + rs.homopart * rs.homopart;
	}
	
	}
	
	ISheterozygosis = 1- ISheterozygosis;
	ISheterozygosis = ((ISheterozygosis)/(secnumber -1))*secnumber;
	rs.SH = 1- ((1- ISheterozygosis)/(1-MASHheterozygosis));
	
	free(rs.microflag);
	free(compositesize);
	for (i=0;i<secnumber;i++){
	free(*(rs.ISchain + i));
	}
	free(rs.ISchain);
	return (rs.SH);
}

float MASH (int **size, int mnumber, int secnumber){
int i, j, k;
char *chain;
rs.microflag = NULL;

rs.microflag = malloc(secnumber * sizeof(int));
rs.microchain = malloc (secnumber*sizeof(char*));
int *compositesize;
	for (i=0;i<secnumber;i++){
	*(rs.microchain + i) = malloc((6*mnumber)*sizeof(char));
	strcpy(*(rs.microchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){
	chain = malloc (6*sizeof(char));
	sprintf(chain,"%i",*(*(size+i)+j));
	strcat(*(rs.microchain + i),chain);
	free(chain);
	}
	}
	


float heterozygosismean = 0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(rs.microchain + k),*(rs.microchain + j)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	heterozygosismean = heterozygosismean + rs.homopart * rs.homopart;
	}
	
	}
	
	heterozygosismean = 1- heterozygosismean;
	heterozygosismean = ((heterozygosismean)/(secnumber -1))*secnumber;
	compositesize = malloc (secnumber*sizeof(int));
	for (i=0;i<secnumber;i++){
	*(compositesize + i) = 0;
	for (j=0;j<mnumber;j++){
	*(compositesize + i) = *(compositesize + i) + *(*(size+i)+j);
	}}
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	float MASHheterozygosis = 0;
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if(*(compositesize + j) == *(compositesize + k)){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	MASHheterozygosis = MASHheterozygosis + rs.homopart * rs.homopart;
	}
	}
	MASHheterozygosis = 1- MASHheterozygosis;
	MASHheterozygosis = ((MASHheterozygosis)/(secnumber -1))*secnumber;
//	printf("MASHheterozygosis = %f heterocigosis = %f\n",MASHheterozygosis, heterozygosismean);
	rs.MASH = 1- ((1- heterozygosismean)/(1- MASHheterozygosis));
		for (i=0;i<secnumber;i++){
	free(*(rs.microchain + i));
	}
	free(rs.microflag);
	free(rs.microchain);
	free(compositesize);
	return (rs.MASH);
}

float SASH (int **size, int mnumber, int secnumber, char ***infinite){
int i, j, k;
rs.microflag = NULL;

float ISheterozygosis = 0;
rs.microflag = malloc(secnumber * sizeof(int));

char *chain;
rs.microchain = malloc (secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
	*(rs.microchain + i) = malloc((6*mnumber)*sizeof(char));
	strcpy(*(rs.microchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){
	chain = malloc (6*sizeof(char));
	sprintf(chain,"%i",*(*(size+i)+j));
	strcat(*(rs.microchain + i),chain);
	free(chain);
	}
	}
	


float heterozygosismean = 0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(rs.microchain + k),*(rs.microchain + j)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	heterozygosismean = heterozygosismean + rs.homopart * rs.homopart;
	}
	
	}
	
	heterozygosismean = 1- heterozygosismean;
	heterozygosismean = ((heterozygosismean)/(secnumber -1))*secnumber;
rs.ISchain = malloc(secnumber*sizeof(char*));
for (i=0;i<secnumber;i++){
	*(rs.ISchain + i) = malloc((rs.segsites*mnumber)*sizeof(char));
	strcpy(*(rs.ISchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){
	chain = malloc (rs.segsites*sizeof(char));
	sprintf(chain,"%i",*(*(infinite+i)+j));
	strcat(*(rs.ISchain + i),*(*(infinite+i)+j));
	free(chain);
	}
	}
	

	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(rs.ISchain + k),*(rs.ISchain + j)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	ISheterozygosis = ISheterozygosis + rs.homopart * rs.homopart;
	}
	
	}
	
	ISheterozygosis = 1- ISheterozygosis;
	ISheterozygosis = ((ISheterozygosis)/(secnumber -1))*secnumber;
	//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	
	rs.SASH = 0;
	rs.SASH = 1-((1 - ISheterozygosis)/(1-heterozygosismean));
	//printf("SH = %f, ISheterozygosis = %f, heterozygosismicro = %f\n",rs.SH,ISheterozygosis,heterozygosismean);
	for (i=0;i<secnumber;i++){
	free(*(rs.microchain + i));
	}
	for (i=0;i<secnumber;i++){
	free(*(rs.ISchain + i));
	}
	free(rs.microflag);
	free(rs.ISchain);
	free(rs.microchain);
	
	return (rs.SASH);
}

float SHchanges (int **size, int mnumber, int secnumber, char ***infinite){

char *chain;
int ISchanges, j, i;
chain = malloc (rs.segsites*sizeof(char));
ISchanges = 0;
for (j=0;j<mnumber;j++){
ISchanges = ISchanges + strlen(*(*(infinite+0)+j));
//printf("%s",*(*(infinite+0)+j));
}
//printf("Tu cadena = %s\n",chain);

//printf("cambios = %i %s\n",ISchanges,chain);



int microchanges = 0.0;
int min, max;
for (j=0;j<mnumber;j++){
min = *(*(size+0)+j);
max = *(*(size+0)+j);
for (i=0;i<secnumber;i++){
if(*(*(size+i)+j)<min){min=*(*(size+i)+j);}
if(*(*(size+i)+j)>max){max=*(*(size+i)+j);}
	}
microchanges = microchanges + (max - min);	
	}

rs.SHchanges = (1 -(((float)microchanges)/((float)ISchanges)));
//	printf("chanIS = %i, chanmic = %i\n", ISchanges,microchanges);
	return(rs.SHchanges);
}

float SHdistance (int **size, int mnumber, int secnumber, char ***infinite){
int maximum = 0;
int differencepairs = 0;
//differencepairs = NULL;
//printf("grgue");
int i, j, k, l;
rs.pairmaximum = 0;
rs.microminsize = malloc (mnumber * sizeof (int) );
rs.micromaxsize = malloc (mnumber * sizeof (int) );
int sites = 0;
int counter = 0;
for (k=0;k<mnumber;k++){
*(rs.microminsize + k ) = *(*(size + 0)+k);
*(rs.micromaxsize + k ) = *(*(size + 0)+k);
for(j=0;j<secnumber;j++){
if(*(*(size + j)+k) < *(rs.microminsize + k )){
*(rs.microminsize + k ) = *(*(size + j)+k);
}
if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
*(rs.micromaxsize + k ) = *(*(size + j)+k);
}
}

}

float pimicro = 0;
float fraction;
for(i=0;i<rs.micronumber;i++){
for(k=*(rs.microminsize + i );k<*(rs.micromaxsize + i);k++){
fraction = 0;
for(j=0;j<pars.cp.nsam;j++){
if (*(*(size + j)+i) > k){
fraction++;
}}
fraction=fraction/pars.cp.nsam;
pimicro = pimicro + 2*(fraction)*(1-fraction);
//fprintf(stderr,"fraction = %f\n",fraction);
//fprintf(stderr,"pimicro = %f\n",pimicro);
}}
//fprintf(stderr,"pimicro2 = %f\n",pimicro);
char *chain,*chain2;
int number, dist;
float piIS = 0;
for(i=0;i<rs.micronumber;i++){
dist = strlen(*(*(infinite+0)+i));
//printf("dist = %i ",dist);
for(l=0;l<dist;l++){
fraction = 0;
for(j=0;j<pars.cp.nsam;j++){

chain = malloc (1*sizeof(char));
sprintf(chain,"%c",*(*(*(infinite+j)+i)+l));
//printf("%s %s ",chain,chain2);
number = atoi(chain);
//printf("%i %i\n",*number,*number2);

if(number == 0){
fraction++;
}
free(chain);

}
fraction=fraction/pars.cp.nsam;

piIS = piIS +2*(fraction)*(1-fraction);
//fprintf(stderr,"fractionIS = %f\n",fraction);
//fprintf(stderr,"piIS = %f\n",piIS);
}}

//printf("SMMdist= %i ISdistance = %i",differencepairs,ISdistance);
rs.SHdist = ((float)piIS - (float)pimicro )/(float)piIS;
//printf("SHdist = %f\n",rs.SHdist);

free(rs.microminsize);
free(rs.micromaxsize);
return(rs.SHdist);
}

float HomoBC(int **size, int mnumber, int secnumber, char ***infinite){
int i, j, k;
rs.microflag = NULL;
rs.microflag = malloc(secnumber * sizeof(int));
		for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	rs.numberconfigurations = secnumber;
	
		for(i=0;i<secnumber;i++){
		if(*(rs.microflag + i) == 0){
		for(j=i+1;j<secnumber;j++){
		rs.configflag =0;
		
		for(k=0;k<mnumber;k++){
		if(*(*(size + i)+k)  != *(*(size + j)+k)){
		rs.configflag = 1;
		}
		}
		if(rs.configflag ==0){
		*(rs.microflag + j) = 1;
		rs.numberconfigurations = rs.numberconfigurations -1; 
		}
		}
		}
		}
		//printf("\nTu número de configuraciones es %i",rs.numberconfigurations);
		//printf("%i\n",rs.numberconfigurations);
rs.ISchain = malloc(secnumber*sizeof(char*));
for (i=0;i<secnumber;i++){
	*(rs.ISchain + i) = malloc((rs.segsites*mnumber)*sizeof(char));
	strcpy(*(rs.ISchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){

	strcat(*(rs.ISchain + i),*(*(infinite+i)+j));

	}
	}
	rs.ISconfigurations = secnumber;
	
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
		for(i=0;i<secnumber;i++){
		if(*(rs.microflag + i) == 0){
		for(j=i+1;j<secnumber;j++){
		rs.configflag =0;
		
		
		if((strcmp(*(rs.ISchain + i),*(rs.ISchain + j)))==0){
		rs.configflag = 1;
		rs.ISconfigurations = rs.ISconfigurations -1;
		*(rs.microflag + j) = 1;
		}

		}
		}
		}
		rs.HBC= 1.0 - ((float)rs.numberconfigurations/(float)rs.ISconfigurations);
		//fprintf(stderr,"%i	%i	%f\n",rs.ISconfigurations, rs.numberconfigurations, rs.HBC);
		for (i=0;i<secnumber;i++){
	free(*(rs.ISchain + i));
	}
		
		free(rs.ISchain);
		free(rs.microflag);
return (rs.HBC);

}

int sitesSMM (int **size, int mnumber, int secnumber){
int microchanges = 0;
int min, max, i , j;
for (j=0;j<mnumber;j++){
min = *(*(size+0)+j);
max = *(*(size+0)+j);
for (i=0;i<secnumber;i++){
if(*(*(size+i)+j)<min){min=*(*(size+i)+j);}
if(*(*(size+i)+j)>max){max=*(*(size+i)+j);}
	}
microchanges = microchanges + (max - min);	
	}
	return (microchanges);
}

int singleton (int **size, int mnumber, int secnumber){
rs.microminsize = malloc (mnumber * sizeof (int) );
rs.micromaxsize = malloc (mnumber * sizeof (int) );
int sites = 0;
int i, j, k, l;
int counter = 0;
for (k=0;k<mnumber;k++){
*(rs.microminsize + k ) = *(*(size + 0)+k);
*(rs.micromaxsize + k ) = *(*(size + 0)+k);
for(j=0;j<secnumber;j++){
if(*(*(size + j)+k) < *(rs.microminsize + k )){
*(rs.microminsize + k ) = *(*(size + j)+k);
}
if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
*(rs.micromaxsize + k ) = *(*(size + j)+k);
}
}

//fprintf(stderr,"%i ",*(rs.microminsize + k ));
//fprintf(stderr,"%i\n",*(rs.micromaxsize + k ));
sites = sites + (*(rs.micromaxsize + k ) - *(rs.microminsize + k ));
}
//Aquí me quedé
int **microbinary;
microbinary = malloc (sites*sizeof(int*));
for(i=0;i<sites;i++){
*(microbinary + i) = malloc (secnumber*sizeof(int));
}
for (i=0;i<secnumber;i++){
counter =0;
for (j=0;j<mnumber;j++){
for (l=0;l<*(*(size + i)+j) - *(rs.microminsize + j );l++){
*(*(microbinary + counter)+i) = 1;
//fprintf(stderr," %i", *(*(microbinary + counter)+i));
counter++;
}

for (l=*(*(size + i)+j) - *(rs.microminsize + j );l<(*(rs.micromaxsize + j ) - *(rs.microminsize + j ));l++){
*(*(microbinary + counter)+i) = 0;
//fprintf(stderr," %i", *(*(microbinary + counter)+i));
counter++;
}
}
//fprintf(stderr,"\n");
//fprintf(stderr,"%i\n",counter);
}


int singleton = 0;
for(i=0;i<sites;i++){
counter = 0;
for (j=0;j<secnumber;j++){
if (*(*(microbinary +i)+j) == 1){counter++;}
}

if (counter ==1){singleton++;}else if(counter == (secnumber-1)){singleton++;}
}
//fprintf(stderr,"Tus singletones = %i",singleton);
for(i=0;i<sites;i++){
free(*(microbinary + i));
}
free(microbinary);
free(rs.microminsize);
free(rs.micromaxsize);


return(singleton);

}

float msitesvar(int **size, int mnumber, int secnumber){

int i, j, k;
rs.microminsize = malloc (mnumber * sizeof (int) );
rs.micromaxsize = malloc (mnumber * sizeof (int) );
for (k=0;k<mnumber;k++){
*(rs.microminsize + k ) = *(*(size + 0)+k);
*(rs.micromaxsize + k ) = *(*(size + 0)+k);
for(j=0;j<secnumber;j++){
if(*(*(size + j)+k) < *(rs.microminsize + k )){
*(rs.microminsize + k ) = *(*(size + j)+k);
}
if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
*(rs.micromaxsize + k ) = *(*(size + j)+k);
}
}
}

float mean = 0;
int *sites;
sites = malloc (mnumber * sizeof (int) );
for(i=0;i<mnumber;i++){

		mean = mean + *(rs.micromaxsize + i ) -*(rs.microminsize + i );
		*(sites + i) = *(rs.micromaxsize + i ) -*(rs.microminsize + i );
	//	fprintf(stderr, "mean = %f\n",mean);
}
		mean = mean/mnumber;
		//fprintf(stderr, "mean = %i\n",mean);
rs.sum = 0;
rs.squaresum = 0;	
for (k=0;k<mnumber;k++){
rs.sum = rs.sum + *(sites + k);
		rs.squaresum = rs.squaresum + (*(sites + k) * *(sites + k));
}
float variance;
variance = (rs.squaresum -((rs.sum*rs.sum)/mnumber))/(mnumber - 1);
	//fprintf(stderr, "variance = %f\n",variance);
free(sites);
free(rs.microminsize);
free(rs.micromaxsize);
return(variance);
}

float hetero(int **size, int mnumber, int secnumber){

int i, j, k;
rs.microflag = NULL;

rs.microflag = malloc(secnumber * sizeof(int));

char *chain;
rs.microchain = malloc (secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
	*(rs.microchain + i) = malloc((6*mnumber)*sizeof(char));
	strcpy(*(rs.microchain + i),"");
	}
	for (i=0;i<secnumber;i++){
	for (j=0;j<mnumber;j++){
	chain = malloc (6*sizeof(char));
	sprintf(chain,"%i",*(*(size+i)+j));
	strcat(*(rs.microchain + i),chain);
	free(chain);
	}
	}
	


float heterozygosismean = 0;
	for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
	rs.homopart = 1./secnumber;
	
	if(*(rs.microflag + k) ==0){
	for (j=k+1;j<secnumber;j++){
	if((strcmp(*(rs.microchain + k),*(rs.microchain + j)))==0){
	rs.homopart = rs.homopart + (1./secnumber);
	*(rs.microflag + j) = 1;
	
	}
	}
	heterozygosismean = heterozygosismean + rs.homopart * rs.homopart;
	}
	
	}
	
	heterozygosismean = 1- heterozygosismean;
	heterozygosismean = ((heterozygosismean)/(secnumber -1))*secnumber;
for (i=0;i<secnumber;i++){
	free(*(rs.microchain + i));
	}

	free(rs.microflag);
	free(rs.microchain);
	return(heterozygosismean);
}

float configmicmean (int **size, int mnumber, int secnumber){

int i, j, k;
int *micros;
micros = malloc(secnumber * sizeof(int));
float meannumberconfig = 0.0;
int numberconfigurations;
int *config;
config = malloc(mnumber * sizeof(int));
float mean = 0.0;
		for(k=0;k<mnumber;k++){
		for (i=0;i<secnumber;i++){
	*(micros + i) =0;
	}
	numberconfigurations = secnumber;
		for(i=0;i<secnumber;i++){
		if(*(micros + i) == 0){
		for(j=i+1;j<secnumber;j++){
		if(*(*(size + i)+k)  == *(*(size + j)+k)){
		*(micros + j) = 1;
		numberconfigurations = numberconfigurations -1; 
		}
		}
		}
		}
		*(config + k) =numberconfigurations;
		mean = mean + numberconfigurations;
		//fprintf(stderr,"k = %i, number = %i\n",mnumber,*(config + k));
		}
		mean = mean / mnumber;
		//fprintf(stderr,"va\n");
		//printf("\nnumber of config =%f\n",meannumberconfig);
rs.sum = 0;
rs.squaresum = 0;

for(i=0;i<mnumber;i++){


		rs.sum = rs.sum + *(config + i);
		rs.squaresum = rs.squaresum + (*(config + i) * *(config + i));
		
		}	
		meannumberconfig = (rs.squaresum -((rs.sum*rs.sum)/mnumber))/(mnumber - 1);	
		//printf("\nTu número de configuraciones es %i",rs.numberconfigurations);
		//printf("%i\n",rs.numberconfigurations);
		free(micros);
		return (meannumberconfig);
}


int numberofconfigurationsIS(char ***size, int mnumber, int secnumber){
int i, j, k, l, count, flag;
rs.microflag =malloc(secnumber * sizeof(int));
//rs.configs = malloc (secnumber * sizeof (int));
l = 0;
		for (k=0;k<secnumber;k++){
	*(rs.microflag + k) =0;
	}
	rs.numberconfigurations = secnumber;
	
		for(i=0;i<secnumber;i++){
		if(*(rs.microflag + i) == 0){
		for(j=i+1;j<secnumber;j++){
		rs.configflag =0;
		
		for(k=0;k<mnumber;k++){
		if(strcmp(*(*(size + i)+k), *(*(size + j)+k)) !=0){
		rs.configflag = 1;
		}
		}
		if(rs.configflag ==0){
		*(rs.microflag + j) = 1;
		rs.numberconfigurations = rs.numberconfigurations -1; 
		}
		}
		*(rs.configs + l) = i;
		l++;
		}
		}
	//	printf("\nTu número de configuraciones es %i\n",rs.numberconfigurations);
		//printf("%i\n",rs.numberconfigurations);
		for (i=0;i < rs.numberconfigurations; i ++){
	//	printf ("config num =%i	number = %i\n", i, *(rs.configs + i));
		}
rs.hapnumber = malloc (rs.numberconfigurations * sizeof (int));
for (i=0; i<rs.numberconfigurations; i ++){
count = 0;
for(j=0;j<secnumber;j++){
flag = 0;
for (k=0;k<mnumber;k++){
if (strcmp(*(*(size + j)+k), *(*(size + *(rs.configs + i))+k))!=0){
flag = 1;
}
}
if (flag == 0){
count ++;
}
}
*(rs.hapnumber + i) = count;
//printf ("hap = %i, numero = %i\n", i, *(rs.hapnumber + i));
}


free(rs.microflag);
		return (rs.numberconfigurations);
}

float ISmicHeterozygosis (int **size, int mnumber, int secnumber, char ***infinite){
	int i, j, k;
	rs.microflag = NULL;
	rs.heterozygosis = NULL;
	
	rs.microflag = malloc(secnumber * sizeof(int));
	rs.heterozygosis = malloc(mnumber * sizeof(float));
	rs.infinite_heterozygosis = malloc(mnumber * sizeof(float));
	rs.homoplasyloc = malloc (mnumber * sizeof (float));
	for (i=0;i<mnumber;i++){
		*(rs.heterozygosis + i) = 0;
	}
	float heterozygosismean =0;
	rs.denominatorsquare = NULL;
	rs.denominatorsquare = malloc(mnumber * sizeof(float*));
	for (i=0;i<mnumber;i++){
		*(rs.denominatorsquare + i) = NULL;
		*(rs.denominatorsquare + i) = malloc(secnumber*sizeof(float));
		for (j=0;j<secnumber;j++){
			*(*(rs.denominatorsquare + i)+j) = 0;
		}
	}
	for (i=0;i<mnumber;i++){
		rs.counterfreq=0;
		for (k=0;k<secnumber;k++){
			*(rs.microflag + k) =0;
		}
		
		for (k=0;k<secnumber;k++){
			rs.homopart = 1./secnumber;
			
			if(*(rs.microflag + k) ==0){
				for (j=k+1;j<secnumber;j++){
					if(*(*(size + k)+i)  == *(*(size + j)+i)){
						rs.homopart = rs.homopart + (1./secnumber);
						*(rs.microflag + j) = 1;
						
					}
				}
				
				*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
				rs.counterfreq++;
				*(rs.heterozygosis + i) = *(rs.heterozygosis + i) + rs.homopart * rs.homopart;
			}
			
		}
		
		*(rs.heterozygosis + i) = 1- *(rs.heterozygosis + i);
		*(rs.heterozygosis + i) = ((*(rs.heterozygosis + i))/(secnumber -1))*secnumber;
		heterozygosismean = heterozygosismean + *(rs.heterozygosis + i);
	}
	heterozygosismean = heterozygosismean/mnumber;
	for (i=0;i<mnumber;i++){
		*(rs.infinite_heterozygosis + i) = 0;
	}
	for (i=0;i<mnumber;i++){
		for (j=0;j<secnumber;j++){
			*(*(rs.denominatorsquare + i)+j) = 0;
		}
	}
	for (i=0;i<mnumber;i++){
		rs.counterfreq=0;
		for (k=0;k<secnumber;k++){
			*(rs.microflag + k) =0;
		}
		
		for (k=0;k<secnumber;k++){
			rs.homopart = 1./secnumber;
			
			if(*(rs.microflag + k) ==0){
				for (j=k+1;j<secnumber;j++){
					if((strcmp(*(*(rs.infinitesitepart + k)+i),*(*(rs.infinitesitepart + j)+i)))==0){
						rs.homopart = rs.homopart + (1./secnumber);
						*(rs.microflag + j) = 1;
						
					}
				}
				
				*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
				rs.counterfreq++;
				*(rs.infinite_heterozygosis + i) = *(rs.infinite_heterozygosis + i) + rs.homopart * rs.homopart;
			}
			
		}
		
		*(rs.infinite_heterozygosis + i) = 1- *(rs.infinite_heterozygosis + i);
		*(rs.infinite_heterozygosis + i) = ((*(rs.infinite_heterozygosis + i))/(secnumber -1))*secnumber;
		//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	}
	rs.TempISMic = 0;
	for (i=0;i<mnumber;i++){
		*(rs.homoplasyloc + i) = (1-*(rs.infinite_heterozygosis + i));
		//printf("heterozygosis = %f con micro %i\n",*(rs.infinite_heterozygosis + i), i);
		rs.TempISMic = rs.TempISMic + *(rs.homoplasyloc + i);
	}
	rs.TempISMic = rs.TempISMic/mnumber;
	free(rs.microflag);
	for (i=0;i<mnumber;i++){
		free(*(rs.denominatorsquare + i));
	}
	free(rs.denominatorsquare);
	free(rs.heterozygosis);
	free(rs.infinite_heterozygosis);
	free(rs.homoplasyloc);
	return(rs.TempISMic);
}

float SMMmichomoplasyloc (int **size, int mnumber, int secnumber, char ***infinite){
	int i, j, k;
	rs.microflag = NULL;
	rs.heterozygosis = NULL;
	
	rs.microflag = malloc(secnumber * sizeof(int));
	rs.heterozygosis = malloc(mnumber * sizeof(float));
	rs.infinite_heterozygosis = malloc(mnumber * sizeof(float));
	rs.homoplasyloc = malloc (mnumber * sizeof (float));
	for (i=0;i<mnumber;i++){
		*(rs.heterozygosis + i) = 0;
	}
	float heterozygosismean =0;
	rs.denominatorsquare = NULL;
	rs.denominatorsquare = malloc(mnumber * sizeof(float*));
	for (i=0;i<mnumber;i++){
		*(rs.denominatorsquare + i) = NULL;
		*(rs.denominatorsquare + i) = malloc(secnumber*sizeof(float));
		for (j=0;j<secnumber;j++){
			*(*(rs.denominatorsquare + i)+j) = 0;
		}
	}
	for (i=0;i<mnumber;i++){
		rs.counterfreq=0;
		for (k=0;k<secnumber;k++){
			*(rs.microflag + k) =0;
		}
		
		for (k=0;k<secnumber;k++){
			rs.homopart = 1./secnumber;
			
			if(*(rs.microflag + k) ==0){
				for (j=k+1;j<secnumber;j++){
					if(*(*(size + k)+i)  == *(*(size + j)+i)){
						rs.homopart = rs.homopart + (1./secnumber);
						*(rs.microflag + j) = 1;
						
					}
				}
				
				*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
				rs.counterfreq++;
				*(rs.heterozygosis + i) = *(rs.heterozygosis + i) + rs.homopart * rs.homopart;
			}
			
		}
		
		*(rs.heterozygosis + i) = 1- *(rs.heterozygosis + i);
		*(rs.heterozygosis + i) = ((*(rs.heterozygosis + i))/(secnumber -1))*secnumber;
		heterozygosismean = heterozygosismean + *(rs.heterozygosis + i);
	}
	heterozygosismean = heterozygosismean/mnumber;
	for (i=0;i<mnumber;i++){
		*(rs.infinite_heterozygosis + i) = 0;
	}
	for (i=0;i<mnumber;i++){
		for (j=0;j<secnumber;j++){
			*(*(rs.denominatorsquare + i)+j) = 0;
		}
	}
	for (i=0;i<mnumber;i++){
		rs.counterfreq=0;
		for (k=0;k<secnumber;k++){
			*(rs.microflag + k) =0;
		}
		
		for (k=0;k<secnumber;k++){
			rs.homopart = 1./secnumber;
			
			if(*(rs.microflag + k) ==0){
				for (j=k+1;j<secnumber;j++){
					if((strcmp(*(*(rs.infinitesitepart + k)+i),*(*(rs.infinitesitepart + j)+i)))==0){
						rs.homopart = rs.homopart + (1./secnumber);
						*(rs.microflag + j) = 1;
						
					}
				}
				
				*(*(rs.denominatorsquare + i) + rs.counterfreq) = rs.homopart;
				rs.counterfreq++;
				*(rs.infinite_heterozygosis + i) = *(rs.infinite_heterozygosis + i) + rs.homopart * rs.homopart;
			}
			
		}
		
		*(rs.infinite_heterozygosis + i) = 1- *(rs.infinite_heterozygosis + i);
		*(rs.infinite_heterozygosis + i) = ((*(rs.infinite_heterozygosis + i))/(secnumber -1))*secnumber;
		//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	}
	rs.TempSMMMic = 0;
	for (i=0;i<mnumber;i++){
		*(rs.homoplasyloc + i) = (1-*(rs.heterozygosis + i));
		//printf("heterozygosis = %f con micro %i\n",*(rs.infinite_heterozygosis + i), i);
		rs.TempSMMMic = rs.TempSMMMic + *(rs.homoplasyloc + i);
	}
	rs.TempSMMMic = rs.TempSMMMic/mnumber;
	free(rs.microflag);
	for (i=0;i<mnumber;i++){
		free(*(rs.denominatorsquare + i));
	}
	free(rs.denominatorsquare);
	free(rs.heterozygosis);
	free(rs.infinite_heterozygosis);
	free(rs.homoplasyloc);
	return(rs.TempSMMMic);
}

float ISdist (int **size, int mnumber, int secnumber, char ***infinite){
	int maximum = 0;
	int differencepairs = 0;
	//differencepairs = NULL;
	//printf("grgue");
	int i, j, k, l;
	rs.pairmaximum = 0;
	rs.microminsize = malloc (mnumber * sizeof (int) );
	rs.micromaxsize = malloc (mnumber * sizeof (int) );
	int sites = 0;
	int counter = 0;
	for (k=0;k<mnumber;k++){
		*(rs.microminsize + k ) = *(*(size + 0)+k);
		*(rs.micromaxsize + k ) = *(*(size + 0)+k);
		for(j=0;j<secnumber;j++){
			if(*(*(size + j)+k) < *(rs.microminsize + k )){
				*(rs.microminsize + k ) = *(*(size + j)+k);
			}
			if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
				*(rs.micromaxsize + k ) = *(*(size + j)+k);
			}
		}
		
	}
	
	float pimicro = 0;
	float fraction;
	for(i=0;i<rs.micronumber;i++){
		for(k=*(rs.microminsize + i );k<*(rs.micromaxsize + i);k++){
			fraction = 0;
			for(j=0;j<pars.cp.nsam;j++){
				if (*(*(size + j)+i) > k){
					fraction++;
				}}
			fraction=fraction/pars.cp.nsam;
			pimicro = pimicro + 2*(fraction)*(1-fraction);
			//fprintf(stderr,"fraction = %f\n",fraction);
			//fprintf(stderr,"pimicro = %f\n",pimicro);
		}}
	//fprintf(stderr,"pimicro2 = %f\n",pimicro);
	char *chain,*chain2;
	int number, dist;
	float piIS = 0;
	for(i=0;i<rs.micronumber;i++){
		dist = strlen(*(*(infinite+0)+i));
		//printf("dist = %i ",dist);
		for(l=0;l<dist;l++){
			fraction = 0;
			for(j=0;j<pars.cp.nsam;j++){
				
				chain = malloc (1*sizeof(char));
				sprintf(chain,"%c",*(*(*(infinite+j)+i)+l));
				//printf("%s %s ",chain,chain2);
				number = atoi(chain);
				//printf("%i %i\n",*number,*number2);
				
				if(number == 0){
					fraction++;
				}
				free(chain);
				
			}
			fraction=fraction/pars.cp.nsam;
			
			piIS = piIS +2*(fraction)*(1-fraction);
			//fprintf(stderr,"fractionIS = %f\n",fraction);
			//fprintf(stderr,"piIS = %f\n",piIS);
		}}
	
	//printf("SMMdist= %i ISdistance = %i",differencepairs,ISdistance);
	rs.TempISDist = (float)piIS;
	//printf("SHdist = %f\n",rs.SHdist);
	
	free(rs.microminsize);
	free(rs.micromaxsize);
	return(rs.TempISDist);
	
}

float SMMdist (int **size, int mnumber, int secnumber, char ***infinite){
	int maximum = 0;
	int differencepairs = 0;
	//differencepairs = NULL;
	//printf("grgue");
	int i, j, k, l;
	rs.pairmaximum = 0;
	rs.microminsize = malloc (mnumber * sizeof (int) );
	rs.micromaxsize = malloc (mnumber * sizeof (int) );
	int sites = 0;
	int counter = 0;
	for (k=0;k<mnumber;k++){
		*(rs.microminsize + k ) = *(*(size + 0)+k);
		*(rs.micromaxsize + k ) = *(*(size + 0)+k);
		for(j=0;j<secnumber;j++){
			if(*(*(size + j)+k) < *(rs.microminsize + k )){
				*(rs.microminsize + k ) = *(*(size + j)+k);
			}
			if(*(*(size + j)+k) > *(rs.micromaxsize + k )){
				*(rs.micromaxsize + k ) = *(*(size + j)+k);
			}
		}
		
	}
	
	float pimicro = 0;
	float fraction;
	for(i=0;i<rs.micronumber;i++){
		for(k=*(rs.microminsize + i );k<*(rs.micromaxsize + i);k++){
			fraction = 0;
			for(j=0;j<pars.cp.nsam;j++){
				if (*(*(size + j)+i) > k){
					fraction++;
				}}
			fraction=fraction/pars.cp.nsam;
			pimicro = pimicro + 2*(fraction)*(1-fraction);
			//fprintf(stderr,"fraction = %f\n",fraction);
			//fprintf(stderr,"pimicro = %f\n",pimicro);
		}}
	//fprintf(stderr,"pimicro2 = %f\n",pimicro);
	char *chain,*chain2;
	int number, dist;
	float piIS = 0;
	for(i=0;i<rs.micronumber;i++){
		dist = strlen(*(*(infinite+0)+i));
		//printf("dist = %i ",dist);
		for(l=0;l<dist;l++){
			fraction = 0;
			for(j=0;j<pars.cp.nsam;j++){
				
				chain = malloc (1*sizeof(char));
				sprintf(chain,"%c",*(*(*(infinite+j)+i)+l));
				//printf("%s %s ",chain,chain2);
				number = atoi(chain);
				//printf("%i %i\n",*number,*number2);
				
				if(number == 0){
					fraction++;
				}
				free(chain);
				
			}
			fraction=fraction/pars.cp.nsam;
			
			piIS = piIS +2*(fraction)*(1-fraction);
			//fprintf(stderr,"fractionIS = %f\n",fraction);
			//fprintf(stderr,"piIS = %f\n",piIS);
		}}
	
	//printf("SMMdist= %i ISdistance = %i",differencepairs,ISdistance);
	rs.TempSMMDist = (float)pimicro;
	//printf("SHdist = %f\n",rs.SHdist);
	
	free(rs.microminsize);
	free(rs.micromaxsize);
	return(rs.TempSMMDist);
}

float IS_P (int **size, int mnumber, int secnumber, char ***infinite){
	int i, j, k;
	rs.microflag = NULL;
	
	float ISheterozygosis = 0;
	rs.microflag = malloc(secnumber * sizeof(int));
	
	char *chain;
	rs.microchain = malloc (secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
		*(rs.microchain + i) = malloc((6*mnumber)*sizeof(char));
		strcpy(*(rs.microchain + i),"");
	}
	for (i=0;i<secnumber;i++){
		for (j=0;j<mnumber;j++){
			chain = malloc (6*sizeof(char));
			sprintf(chain,"%i",*(*(size+i)+j));
			strcat(*(rs.microchain + i),chain);
			free(chain);
		}
	}
	
	
	
	float heterozygosismean = 0;
	for (k=0;k<secnumber;k++){
		*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
		rs.homopart = 1./secnumber;
		
		if(*(rs.microflag + k) ==0){
			for (j=k+1;j<secnumber;j++){
				if((strcmp(*(rs.microchain + k),*(rs.microchain + j)))==0){
					rs.homopart = rs.homopart + (1./secnumber);
					*(rs.microflag + j) = 1;
					
				}
			}
			heterozygosismean = heterozygosismean + rs.homopart * rs.homopart;
		}
		
	}
	
	heterozygosismean = 1- heterozygosismean;
	heterozygosismean = ((heterozygosismean)/(secnumber -1))*secnumber;
	rs.ISchain = malloc(secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
		*(rs.ISchain + i) = malloc((rs.segsites*mnumber)*sizeof(char));
		strcpy(*(rs.ISchain + i),"");
	}
	for (i=0;i<secnumber;i++){
		for (j=0;j<mnumber;j++){
			chain = malloc (rs.segsites*sizeof(char));
			sprintf(chain,"%i",*(*(infinite+i)+j));
			strcat(*(rs.ISchain + i),*(*(infinite+i)+j));
			free(chain);
		}
	}
	
	
	for (k=0;k<secnumber;k++){
		*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
		rs.homopart = 1./secnumber;
		
		if(*(rs.microflag + k) ==0){
			for (j=k+1;j<secnumber;j++){
				if((strcmp(*(rs.ISchain + k),*(rs.ISchain + j)))==0){
					rs.homopart = rs.homopart + (1./secnumber);
					*(rs.microflag + j) = 1;
					
				}
			}
			ISheterozygosis = ISheterozygosis + rs.homopart * rs.homopart;
		}
		
	}
	
	ISheterozygosis = 1- ISheterozygosis;
	ISheterozygosis = ((ISheterozygosis)/(secnumber -1))*secnumber;
	//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	
/*	rs.SASH = 0;
	rs.SASH = 1-((1 - ISheterozygosis)/(1-heterozygosismean));*/
	rs.TempPIS = 1 - ISheterozygosis;
	//printf("SH = %f, ISheterozygosis = %f, heterozygosismicro = %f\n",rs.SH,ISheterozygosis,heterozygosismean);
	for (i=0;i<secnumber;i++){
		free(*(rs.microchain + i));
	}
	for (i=0;i<secnumber;i++){
		free(*(rs.ISchain + i));
	}
	free(rs.microflag);
	free(rs.ISchain);
	free(rs.microchain);
	
	return (rs.TempPIS);
	
}

float SMM_P (int **size, int mnumber, int secnumber, char ***infinite){
	int i, j, k;
	rs.microflag = NULL;
	
	float ISheterozygosis = 0;
	rs.microflag = malloc(secnumber * sizeof(int));
	
	char *chain;
	rs.microchain = malloc (secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
		*(rs.microchain + i) = malloc((6*mnumber)*sizeof(char));
		strcpy(*(rs.microchain + i),"");
	}
	for (i=0;i<secnumber;i++){
		for (j=0;j<mnumber;j++){
			chain = malloc (6*sizeof(char));
			sprintf(chain,"%i",*(*(size+i)+j));
			strcat(*(rs.microchain + i),chain);
			free(chain);
		}
	}
	
	
	
	float heterozygosismean = 0;
	for (k=0;k<secnumber;k++){
		*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
		rs.homopart = 1./secnumber;
		
		if(*(rs.microflag + k) ==0){
			for (j=k+1;j<secnumber;j++){
				if((strcmp(*(rs.microchain + k),*(rs.microchain + j)))==0){
					rs.homopart = rs.homopart + (1./secnumber);
					*(rs.microflag + j) = 1;
					
				}
			}
			heterozygosismean = heterozygosismean + rs.homopart * rs.homopart;
		}
		
	}
	
	heterozygosismean = 1- heterozygosismean;
	heterozygosismean = ((heterozygosismean)/(secnumber -1))*secnumber;
	rs.ISchain = malloc(secnumber*sizeof(char*));
	for (i=0;i<secnumber;i++){
		*(rs.ISchain + i) = malloc((rs.segsites*mnumber)*sizeof(char));
		strcpy(*(rs.ISchain + i),"");
	}
	for (i=0;i<secnumber;i++){
		for (j=0;j<mnumber;j++){
			chain = malloc (rs.segsites*sizeof(char));
			sprintf(chain,"%i",*(*(infinite+i)+j));
			strcat(*(rs.ISchain + i),*(*(infinite+i)+j));
			free(chain);
		}
	}
	
	
	for (k=0;k<secnumber;k++){
		*(rs.microflag + k) =0;
	}
	
	for (k=0;k<secnumber;k++){
		rs.homopart = 1./secnumber;
		
		if(*(rs.microflag + k) ==0){
			for (j=k+1;j<secnumber;j++){
				if((strcmp(*(rs.ISchain + k),*(rs.ISchain + j)))==0){
					rs.homopart = rs.homopart + (1./secnumber);
					*(rs.microflag + j) = 1;
					
				}
			}
			ISheterozygosis = ISheterozygosis + rs.homopart * rs.homopart;
		}
		
	}
	
	ISheterozygosis = 1- ISheterozygosis;
	ISheterozygosis = ((ISheterozygosis)/(secnumber -1))*secnumber;
	//rs.heterozygosismean = rs.heterozygosismean + *(rs.heterozygosis + i);
	
	/*	rs.SASH = 0;
	 rs.SASH = 1-((1 - ISheterozygosis)/(1-heterozygosismean));*/
	rs.TempPSMM = 1 - heterozygosismean;
	//printf("SH = %f, ISheterozygosis = %f, heterozygosismicro = %f\n",rs.SH,ISheterozygosis,heterozygosismean);
	for (i=0;i<secnumber;i++){
		free(*(rs.microchain + i));
	}
	for (i=0;i<secnumber;i++){
		free(*(rs.ISchain + i));
	}
	free(rs.microflag);
	free(rs.ISchain);
	free(rs.microchain);
	
	return (rs.TempPSMM);
}

