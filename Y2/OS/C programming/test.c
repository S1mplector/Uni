int main() {
 printf("\n");
 pid_t p1 = fork();
 pid_t p2 = fork();
 pid_t p3;
 if (p1 > 0 && p2 > 0) {
   p3 = fork();
 }

 printf("Message\n");
 return 0;
}

