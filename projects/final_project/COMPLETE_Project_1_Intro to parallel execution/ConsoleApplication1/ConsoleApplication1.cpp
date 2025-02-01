// For this project you have to add some OpenMP code to make the execution parallel.
// Then you have to change the NUMT constant to take execution times for different number of threads.
// The constant variable NUMTRIES is used for giving you 10 timing results for each execution.
// You have to take the average of the 10 timing results as the final result for each execution 
// which you will use to draw graphs.
// You will get results for different number of threads and different array sizes. 
// You will find the results in a .txt file in the project's folder named as "results_with_NUMT_threads.txt"
// You have to draw graphs each array size versus the calculations/sec for at least 1,2,4,6,8 threads.
// Draw the graphs speedup versus number of threads.
// Draw the graphs for each array size on the same sheet to be easier to compare the results.
// Describe the results on your report. Why do you think you got those results? Is there any improvement you can do?
// How the thread number and the array size affect the execution?

#include "stdafx.h"
#include <stdio.h>
#include <math.h>
#include <fstream>
#include <stdlib.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <iomanip>
#include <omp.h>

#define NUMT	    8			// Change this to add more threads. 	
#define NUMTRIES	10			// Don't change this.

int main()
{
	#ifndef _OPENMP
		fprintf(stderr, "OpenMP is not supported here -- sorry.\n");
		return 1;
	#endif

	omp_set_num_threads(8);

	

	double maxmmults = 0.0;
	double summmults = 0.0;
	double time0     = 0.0;
	double time1     = 0.0;
	double mmults    = 0.0;



	//  Creates a file for the results. The filename includes the number of threads used.
	std::ofstream ofStream;
	char output_File[50];
	if (NUMT == 1)
		snprintf(output_File, 50, "results_with_%d_thread.txt", NUMT);
	else
		snprintf(output_File, 50, "results_with_%d_threads.txt", NUMT);

	ofStream.open(output_File, std::ofstream::app);
	//  Header for the file.
	ofStream << "Number Of Threads		" << "Array Size		" << "Peak Performance		" << "Average Performance		" << std::endl;

	
	for (int ARRAYSIZE = 2000; ARRAYSIZE <= 50000000; ARRAYSIZE *= 5)
	{

		float* A = new float[ARRAYSIZE];
		float* B = new float[ARRAYSIZE];
		float* C = new float[ARRAYSIZE];

		#pragma omp parallel for schedule(static)  
		for (int t = 0; t < NUMTRIES; t++)
		{
			time0 = omp_get_wtime();

			for (int i = 0; i < ARRAYSIZE; i++)
			{
				C[i] = A[i] * B[i];
			}

			time1 = omp_get_wtime();
			mmults = (double)ARRAYSIZE / (time1 - time0) / 1000000.;
			summmults += mmults;
			if (mmults > maxmmults)
			{
				maxmmults = mmults;
			}

		}



		ofStream << std::setw(17) << std::right << NUMT << "		"
			<< std::setw(10) << std::right << ARRAYSIZE << "		"
			<< std::setw(16) << std::setprecision(10) << maxmmults << "		"
			<< std::setw(19) << std::setprecision(10) << summmults / (double)NUMTRIES << std::endl;
	}

	
	ofStream.close();
	return 0;
}