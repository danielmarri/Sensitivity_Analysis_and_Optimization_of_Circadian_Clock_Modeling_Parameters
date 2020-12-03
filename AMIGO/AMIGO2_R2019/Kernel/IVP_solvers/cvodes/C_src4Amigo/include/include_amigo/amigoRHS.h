#include <AMIGO_model.h>

int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data);

void amigoRHS_get_OBS(void* data);