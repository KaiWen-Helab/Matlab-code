%�����ܣ������ԭͼ����й淶�������������С��Ϊ��[369��680]�������ڱ�ע�淶�����ļ����У�����������λ�ã���¼����������ļ������ǰ�����ں�
%created by zhangyan 2019-8-10;

clear
tr_dir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\���ԭͼ';
jpgstr = dir([tr_dir '\*.jpg']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
for i=1:fn
    imname1=strcat(tr_dir,'\',filenames{i});    
    im1=imread(imname1);
    imnn=imresize(im1, [369,680],'nearest');
    newdir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\��ע�淶����\';
    jiaozhengname=strcat(newdir,filenames{i});
    imwrite(uint8(imnn),jiaozhengname);
    imn=rgb2hsv(imnn);
    bw=roicolor(imn(:,:,1),0.155,0.165);
    [m,n]=size(imn(:,:,1));
    [xb,yb]=find(bw==1);
    xbm=mean(xb);
    ybm=mean(yb);
    newdir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\�������\';
    reconame=strcat(newdir,filenames{i});
    reconame=strcat(reconame(1:end-3),'txt');
    fid=fopen(reconame,'w+');
    fprintf(fid,'%f\t%f',xbm,ybm);
    fclose(fid);    

 end

