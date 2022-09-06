#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
int buffer;//make buffer into array
sem_t mutex;
sem_t empty;
sem_t full;
/*void exitSig(int sig){
        printf("Exiting, signal: %d\n", sig);
        (void) signal (SIGINT, SIG_DFL);
        }*/

void *producerWork(void *args){
        int* BufferSize = (int*) args;
        int* TimeInterval = BufferSize++;
        while(1){
                if(buffer < *BufferSize){
                        buffer++;
                }
                printf("Producer thread with buffer %d\n", buffer);
                fflush(stdout);
                sleep(*TimeInterval);
        }
}

void *consumerWork(void *args){
        int* BufferSize = (int*) args;
        int* TimeInterval = BufferSize++;
        while(1){
                if(buffer == *BufferSize){
                        buffer--;
                        printf("Deleting\n");
                }
                printf("Consumer thread with buffer %d\n", buffer);
                fflush(stdout);
                sleep(*TimeInterval);
                }
}

int main(int argc, char *argv[]){
        if(argc !=4){
    printf("enter 3 integers");
    return 0;
  }
        int n = atoi(argv[1]);
        int BufferSize = atoi(argv[2]);
        int TimeInterval = atoi(argv[3]);
        int args[] = {BufferSize, TimeInterval};
        //(void) signal (SIGINT, exitSig);

        pthread_t threads[n+1];
        int ti;
        for(long i =0; i < n+1; i++){
                if(i == n){
                        ti = pthread_create(&threads[n], NULL, producerWork, (void *)args);
                }
                else{
                        ti = pthread_create(&threads[n], NULL, consumerWork, (void *)args);
                }
                if(ti){
                        printf("Error: return code from thread creation is %d\n", ti);
                        exit(-1);
                }
        }
        pthread_exit(NULL);
        return 0;
}
