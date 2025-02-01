// For this project you have to add some OpenMP code to make the execution parallel.
// See the note pack "11_cache.2pp.pdf" for more information.
// Then you have to change the NUMT constant to take execution times for different number of threads.
// You also need to change the padding for the first fix and make the array variable private for the second fix.
// The constant variable NUMTRIES is used for giving you 10 timing results for each execution.
// You have to take the average of the 10 timing results as the final result for each execution 
// which you will use to draw graphs.
// To get results for 0 padding, just comment out the line "int pad[16];" at the struct s definition.
// You will get results for different number of threads for each one of the fixes. 
// You will find the results in a .txt file in the project's folder named as "NUMT_thread_fixFIX_padding:NUM.tx"
// You have to draw graphs for the speedup versus the padding for at least 1,2,4,6,8 threads and 0,2,4,6,8,10,12,14,16,18 padding values.
// Draw the graphs for each array size on the same sheet to be easier to compare the results.
// You also have to draw the speedup which you get with the fix 2 on the same graph.
// Describe the results on your report. Why do you think you got those results? Is there any improvement you can do?
// How the thread number and the array size affect the execution?

#include "stdafx.h"
#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
#include <math.h>
#include <omp.h>


#define NUMT		8
#define NUM			16	// <-- Change this to the padding value you used below.
#define FIX			1	// <-- Change this to according which fix you use.
#define NUMTRIES	10


struct s
{
	float value;
	int pad[16];		// <-- Change this to add padding.
} Array[4];


int main(int argc, char *argv[])
{
#ifndef _OPENMP
	fprintf(stderr, "OpenMP is not available\n");
	return 1;
#endif

	unsigned int someBigNumber = 1000000000;

	

//  Creates a file for the results. The filename includes the number of threads
	std::ofstream ofStream;
	char output_File[50];
	if (NUMT == 1)
		snprintf(output_File, 50, "%d_thread_fix%d_padding%d.txt", NUMT, FIX, NUM);
	else
		snprintf(output_File, 50, "%d_threads_fix%d_padding%d.txt", NUMT, FIX, NUM);
	
	ofStream.open(output_File, std::ofstream::app);
//  Header.
	ofStream << "Number Of Threads		" << "Padding		" << "Exec. Time		" << std::endl;
	omp_set_num_threads(8);
#pragma omp parallel for
	for (int t = 0; t < NUMTRIES; t++)
	{
		double time0 = omp_get_wtime();

		for(int i = 0; i < 4; i++)
		{
			for(unsigned int j = 0; j < someBigNumber; j++)
				Array[i].value = Array[i].value + 2.;
		}
	
		double time1    = omp_get_wtime();
		double execTime = (time1 - time0);

		ofStream << std::setw(17) << std::right				 << NUMT	  << "		" 
				 << std::setw(7)  << std::right				 << NUM       << "		" 
				 << std::setw(10) << std::setprecision(10)   << execTime  << std::endl;		
	}
	ofStream.close();

	printf("Done!");
	return 0;
}