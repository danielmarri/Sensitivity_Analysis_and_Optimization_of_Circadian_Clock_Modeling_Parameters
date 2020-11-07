/* Prototype for a CNOstruct */

/*$Id: CNOStructure.h 1372 2012-01-24 11:16:50Z cokelaer $*/

typedef struct
{
	int** interMat;
	int** notMat;
	double** valueSignals;
	double** valueInhibitors;
	double** valueStimuli;
	int* indexSignals;
	int* indexStimuli;
	int* indexInhibitors;
	double* timeSignals;
	int* isState;
	int* isInput;
	int** adjacencyMatrix;
	int** truthTables;
	int* numInputs;
	int* numBits;
	double* odeParameters;
	int nPars;
	int nRows;
	int nCols;
	int nStimuli;
	int nInhibitors;
	int nSignals;
	int nTimes;
	int nExperiments;
	int nStates;
	/*Use this only inside simulations*/
	double** state_array;
	int* state_index;
	double** inhibitor_array;
	double*** sim_results;
	int*** support_truth_tables;
	double(*transfer_function)(double,double,double);
	int maxNumInputs;
	int** truth_tables_index;
	int** input_index;
	int* count_bits;
    double **** sensResults;
    double unknown_ICs;
	double* hillFuncValues;

}CNOStructure;



double normHill(double x, double n, double k);
double hill_function(double x, double n, double k);
double linear_transfer_function(double x, double n, double k);
int* getNumInputs(int **adjMatrix, int n);
int* getNumBits(int* numInputs, int n);
int *findStates(int **adjMatrix, int n);
int** getTruthTables(int** adjMat, int** interMat, int** notMat, int* isState, int* nInputs, int *nBits, int nRows, int nCols);
int *getStateIndex(int **adjMatrix, int n);
int*** get_support_truth_tables(int n, int *nInputs);
int simulateODE(CNOStructure* data,	int exp_num, int verbose, double reltol, double atol, double maxStepSize,
        int maxNumSteps, int maxErrTestFails, int sensi);
int** get_input_index(int** AdjMat, int n, int* numInputs);
int* get_count_bits(int n, int** truth_tables, int* numBits);
int** get_truth_tables_index(int n, int** truth_tables, int* numBits, int* count_bits);