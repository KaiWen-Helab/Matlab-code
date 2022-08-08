%batch analyze polygon mapping (15by15 grid seq) repeated 3 trials (total...
%675 traces)
%input data as excel with 4 column of data exported from
%clampfit...(column1-4:trace,trace start,R1S1 Peak,R1S1 Time)
%export average amp heatmap and ave peak time heatmap(figure and asc file)
%export average heatmap of all the cell (normalized to each cell's ....
%largest response
%created by HKW on 9/30/18, modified by HKW on 11/1/18 to add peak onset
%time criterior

clear
filePath='Y:\whole-cell recording\test\062319 pv-ai32 polygon evoked ipsc  zt12 dob 050419\analysis\'; % Êý¾ÝÂ·¾¶  @#$@#$...
cd(filePath);
excel_list = dir('*.xlsx');
filenames = {excel_list.name}
n_excel = size(excel_list,1)
gridSeq = textread('15by15_15x15cm grid seq.txt');
summap=zeros(15,15)
normSummap=zeros(15,15)
sumArea=[]
Charge=0
sumCharge=[]

for i=1:n_excel
    Area=0
    j=i:n_excel
    cd(filePath);
    fprintf('Analyze and figure excel, %d/%d\n', i, n_excel);
    data = excel_list(i).name;
    rawdata = xlsread(data);
    amp = rawdata(:,3);
    amp = reshape(amp,225,3);
    
    %exclude spontaneous IPSC by only selecting the grid with the following criteria:
    %:at least 2 out of 3 repeats contain peakAmp <-100pA...
    %for the other grids, replace value with 0
    zero=zeros(1,3)
    ampExclude=[]
    x=[]
    
    for m = 1:225           %%exclude mIPSC (assume amp >-60pA, then replace value with 0), otherwise, amp=amp
        x=min(amp(m,:))
%         if amp(m,1)<-60 & amp(m,2)<-60 
%             x=amp(m,:)
%         elseif amp(m,3)<-60 & amp(m,2)<-60
%             x=amp(m,:)
%         elseif amp(m,1)<-60 & amp(m,3)<-60
%             x=amp(m,:)
%         elseif amp(m,1)<-60 & amp(m,2)<-60 & amp(m,3)<-60
%             x=amp(m,:)
%         elseif amp(m,1)<-60 & amp(m,2)>-60 & amp(m,3)>-60
%             x=[amp(m,1) 0 0]
%         elseif amp(m,1)>-60 & amp(m,2)<-60 & amp(m,3)>-60
%             x=[0 amp(m,2) 0]
%         elseif amp(m,1)>-60 & amp(m,2)>-60 & amp(m,3)<-60
%             x=[0 0 amp(m,3)]
%         else
%             x=zero
         %end
        ampExclude=[ampExclude x]   
    end
    ampExclude=reshape(ampExclude,1,225)
    ampExclude=ampExclude'
    ampGrid = sortrows([gridSeq(:,4),ampExclude],1);
    mI=ampGrid(:,2)
    b = reshape(mI,15,15)
    b = b'
    dlmwrite(strcat('heatmap_amp_',num2str(i),'.csv'),b);
    figure(i);
    heatmap(b);
    Amp_fig_name = ['heatmap_amp_',num2str(i),'.jpeg'];
    print(i,'-djpeg',Amp_fig_name);
    summap=summap+b
    minAmp=min(b(:));
    c=b/minAmp;
    
end

    
%     peakOnset = rawdata(:,4)-rawdata(:,5);      %peakOnset time is estimated by substracting the 5-95% risetiem from peakTime 
%     peakOnset = reshape(peakOnset,225,3);
%     peakOnsetGrid = sortrows([gridSeq(:,4),peakOnset],1);
%     sortAll = [ampGrid,peakOnsetGrid(:,2:4)];
%     
%     for n = 1:225
%         for p = 2:4                              %exclude the trial w/o evoked response (IPSC<60pA)
%             if sortAll(n,p)>-60
%                 sortAll(n,(p+3))=NaN
%             else
%                 sortAll(n,(p+3))=sortAll(n,(p+3))
%             end
%         end                
%         
%         for x = 5:7                              %exclude sweep w/o real response, judged by NaN peakOnset time
%             if isnan(sortAll(n,x))==1
%                 sortAll(n,(x-3))=NaN
%             else
%                 sortAll(n,(x-3))=sortAll(n,(x-3))
%             end
%         end
%         
%     %    stdTime = std(sortAll(n,5:7));
%     %    if stdTime>=4
%     %        sortAll(n,2:4)=[NaN NaN NaN]
%     %    else
%     %        sortAll(n,:)=sortAll(n,:)
%     %    end        
%     end
%     
%     %aveAmp = nanmean(sortAll(:,2:4),2);
%     aveAmp=sortAll(:,2);
%     b = reshape(aveAmp,15,15);%convert 1 column data a into matrix b with n row and m colume)
%     b = b'; % switch the row and colume into the same organization as polygon map
%     b(isnan(b))=0;
%     normSummap=normSummap+b; %add all normalized maps together
%     charge=sum(b(:));       %calculate total Inh charge for each cell
%     sumCharge(i)=charge;    %combine charge from each cell into a matrix(sumCharge)
%     for mm=1:15                  %calculate Inh input area by counting how many grids have ipsc<0
%         for nn=1:15
%             if b(mm,nn)<0
%                 Area=Area+1
%             end
%         end
%     end
%     sumArea(i)=Area          %combine area from each cell into a matrix(sumArea)
%     dlmwrite(strcat('heatmap_amp_',num2str(i),'.csv'),b);
%     figure(i);
%     heatmap(b);
%     Amp_fig_name = ['heatmap_amp_',num2str(i),'.jpeg'];
%     print(i,'-djpeg',Amp_fig_name);
%     summap=summap+b
%     minAmp=min(b(:));
%     b=b/minAmp;
%     
%     
%     avePeakTime = mean(sortAll(:,5:7),2);
%     c = reshape(avePeakTime,15,15);%convert 1 column data a into matrix b with n row and m colume)
%     c = c'; % switch the row and colume into the same organization as polygon map
%     c(isnan(c))=0;
%     dlmwrite(strcat('heatmap_peakTime_',num2str(i),'.csv'),c); %write b matrix into txt file with space to seperate each value
%     figure(j)
%     heatmap(c);
%     peakTime_fig_name = ['heatmap_peakTime_',num2str(i),'.jpeg'];
%     print(i,'-djpeg',peakTime_fig_name);   
% %end
% 
meanCharge=sum(sumCharge(:))/n_excel
meanArea=sum(sumArea(:))/n_excel
charge_area=[sumCharge,meanCharge;sumArea,meanArea]
dlmwrite('charge_area.csv',charge_area);

meanMap=summap/n_excel   % calculate the average normalized map of the same group
meanNormMap=normSummap/n_excel
dlmwrite('heatmap_meanMap.csv',meanMap);
dlmwrite('heatmap_meanNormMap.csv',meanNormMap);
figure
heatmap(meanMap);
saveas(gcf,'heatmap_meanMap.jpeg');
figure
heatmap(meanNormMap);
saveas(gcf,'heatmap_meanNormMap.jpeg');


    
