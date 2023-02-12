#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string>
using namespace std;
void print(string &s){
    printf("%s\n", s.c_str());
}
int main(){
    size_t sz = 10000;
    char* buffer = (char *) malloc(sz);
    unsigned long long  headerBytes = 20, sentPackets = 0,
    receivedPackets = 0, droppedPackets = 0, receivedBytes = 0;
    map<string,double> sentTime, receivedTime;
    double time, totalDelay = 0, startTime = 100000, endTime = 0;
    bool f;
    string cumm, prev;
    int i;
    string traceLavel, packetId, packetType;
    int packetSize, src, dest, from , to;
    string event, tFlag;
    string trafficSrc = "exp";
    while(getline(&buffer,&sz,stdin) != -1){
        i = 0;
        f = false;
        event = "";
        tFlag = "";
        while(*(buffer + i) && !isspace(buffer[i])){
            event += buffer[i++];
        }
        while(*(buffer + i) && isspace(buffer[i]))
            i++;
        
        while(*(buffer + i) && !isspace(buffer[i])){
            tFlag += buffer[i++];
        }
        
        prev = tFlag;
        // printf("%s\n", tFlag.c_str());
        if(tFlag != "-t"){
            --i;
            int c = 1;
            while(*(buffer + i)){
                if(isspace(buffer[i])){
                    ++c;
                    if(c == 2){
                        time = atof(tFlag.c_str());
                        // printf("t:%lf\n", time);
                    }
                    else if(c == 3){
                        from = atoi(cumm.c_str());
                        // print(from);
                        // printf("%s\n",from.c_str());
                    }
                    else if(c == 4){
                        to = atoi(cumm.c_str());
                        // print(to);
                    }
                    else if(c == 5){
                        packetType = cumm;
                        // print(packetType);
                    }
                    else if(c == 6){
                        packetSize = atoi(cumm.c_str());
                    }
                    else if(c == 9){
                        src = atoi(cumm.c_str());
                    }
                    else if(c == 10){
                        dest = atoi(cumm.c_str());
                    }
                    else if(c == 12){
                        packetId = cumm;
                    }
                    prev = cumm;
                    cumm = "";
                }
                else{
                    cumm += buffer[i];
                }
                ++i;
            }
            if(packetType == trafficSrc){
                
                // printf("%s\n", packetId.c_str());
                // printf("%s\n", event.c_str());
                if(time < startTime) startTime = time;
                if(time > endTime) endTime = time;
                if(event == "+" && from == src){
                    sentPackets++;
                    sentTime.insert({packetId, time});
                }
                else if(event == "r" && to == dest && receivedTime.find(packetId) == receivedTime.end()){
                    receivedPackets += 1;
                    receivedBytes += packetSize - headerBytes;
                    totalDelay += time - sentTime[packetId];
                    receivedTime.insert({packetId, time});
                }
                else if(event == "d"){
                    ++droppedPackets;
                }
            }
            continue;
            // cout << packetId << "\n";
        }
        else{
            while(*(buffer + i) && isspace(buffer[i]))
            i++;
            while(*(buffer + i)){
                if(isspace(buffer[i])){
                    if(prev == "-t"){
                        time = atof(cumm.c_str());
                        // printf("%lf\n", time);
                        f = true;
                    }
                    else if(prev == "-Nl"){
                        traceLavel = cumm;
                    }
                    else if(prev == "-Ii")
                        packetId = cumm;
                    else if(prev == "-Il")
                        packetSize = atoi(cumm.c_str());
                    else if(prev == "-It")
                        packetType = cumm;
                    prev = cumm;
                    cumm = "";
                    ++i;
                    continue;
                }
                cumm += buffer[i];
                ++i;
            }
        }
        // printf("%s", packetType.c_str());
        if(f && startTime > time)
            startTime = time;
        if(f && endTime < time)
            endTime = time;
        if(event == "d" && packetType == trafficSrc){
            droppedPackets++;
        }
        if(traceLavel != "AGT" || packetType != trafficSrc)
            continue;
        if(event == "r"){
            receivedBytes += packetSize - headerBytes;
            totalDelay += time - sentTime[packetId];
            receivedPackets++;
        }
        else if(event == "s"){
            sentTime.insert({packetId, time});
            sentPackets += 1;
        }
    }
    // printf("start time : %lf end time: %lf repackets: %lld sPackets:%lld\n", startTime, endTime,receivedPackets, sentPackets);
    // printf("%llu\n", receivedPackets);
    printf("%lf %lf %lf %lf \n", receivedBytes * 8. / (endTime - startTime),
    (totalDelay / receivedPackets), receivedPackets * 1. / sentPackets, 
    droppedPackets * 1. / sentPackets);
    // printf("done");
}