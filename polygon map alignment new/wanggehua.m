%����ͼ�������Ϊ��8�е�11�����ģ�������24*24Ϊ��С����չΪ���񣬲������������������ص�ĵ�����Ϊ�����������
%���������15*15�����ݴ�Ϊexcel�ĵ����������������ֵ����Сֵӳ��Ϊ[255,0]�����ɵ���������ͼ��
%created by zhangyan 2019-8-10;


clear
load('E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\dianliunozhen���\diandata.mat','diandata');
diandata0=diandata;
load('E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt12\dianliunozhen���\diandata.mat','diandata');
diandata12=diandata;
mind0=min(min(diandata0));    %��ʾ��������
maxd0=max(max(diandata0));
dm=(diandata0-mind0)/(maxd0-mind0)*255;
figure,
imshow(uint8(dm))
title('ZT0ȫͼӳ��');

mind12=min(min(diandata12));
maxd12=max(max(diandata12));
dm=(diandata12-mind12)/(maxd12-mind12)*255;
figure,
imshow(uint8(dm))
title('ZT12ȫͼӳ��');

dianamp0=zeros(369,680);
dianamp12=zeros(369,680);
heatmap12=zeros(15,15);
heatmap1212=zeros(15,15);

heatmap0=zeros(15,15);
heatmap00=zeros(15,15);

k=1;
q=1;
for i=23:24:368                      %��������
    k=k+1;
    q=1;
    for j=23:24:679
        q=q+1;
        meandian0=sum(sum(diandata0(i:min(i+24,369),j:min(j+24,671))));
        dianamp0(i:min(i+24,369),j:min(j+24,671))=meandian0;
        heatmap0(k,q)=meandian0;
        
        meandian12=sum(sum(diandata12(i:min(i+24,369),j:min(j+24,671))));
        dianamp12(i:min(i+24,369),j:min(j+24,671))=meandian12;
        heatmap12(k,q)=meandian12;
    end
end
q=1;
for j=23:24:679
    q=q+1;
    meandian0=sum(sum(diandata0(1:23,j:min(j+24,671))));
    dianamp0(1:23,j:min(j+24,671))=meandian0;
    heatmap0(1,q)=meandian0;
    
    meandian12=sum(sum(diandata12(1:23,j:min(j+24,671))));
    dianamp12(1:23,j:min(j+24,671))=meandian12;
    heatmap12(1,q)=meandian12;
end
k=1;
for i=23:24:368
    k=k+1;
    meandian0=sum(sum(diandata0(i:min(i+24,369),1:23)));
    dianamp0(i:min(i+24,369),1:23)=meandian0;
    heatmap0(k,1)=meandian0;
    meandian12=sum(sum(diandata12(i:min(i+24,369),1:23)));
    dianamp12(i:min(i+24,369),1:23)=meandian12;
    heatmap12(k,1)=meandian12;
end
meandian0=sum(sum(diandata0(1:23,1:23)));
dianamp0(1:23,1:23)=meandian0;
heatmap0(1,1)=meandian0;
meandian12=sum(sum(diandata12(1:23,1:23)));
dianamp12(1:23,1:23)=meandian12;
heatmap12(1,1)=meandian12;

heatmap00=heatmap0(1:15,7:21);       %��ȡ15*15��EXCEL����
heatmap1212=heatmap12(1:15,7:21);
xlswrite('zt0_nozhen.xlsx',heatmap00);
xlswrite('zt12_nozhen.xlsx',heatmap1212);

maxd=max(max(dianamp0));             %��ʾ����ͼ��
mind=min(min(dianamp0));
dian0=uint8((dianamp0-mind)/(maxd-mind)*255);
dian0(178:180,394:396)=255;
dian0(1:359,143)=0;
dian0(1:359,503)=0;
dian0(1,143:503)=0;
dian0(359,143:503)=0;
dian0n=255-dian0;
figure,
imshow(uint8(dian0));
title('ZT0nozhen��������');
figure,
imshow(uint8(dian0n));
title('ZT0nozhen��������');

maxd=max(max(dianamp12));
mind=min(min(dianamp12));
dian12=uint8((dianamp12-mind)/(maxd-mind)*255);
dian12(178:180,394:396)=255;
dian12(1:359,143)=0;
dian12(1:359,503)=0;
dian12(1,143:503)=0;
dian12(359,143:503)=0;
dian12n=255-dian12;
figure,
imshow(uint8(dian12));
title('ZT12nozhen��������');
figure,
imshow(uint8(dian12n));
title('ZT12nonzhen��������');
