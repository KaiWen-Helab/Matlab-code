%程序功能：对针点原图像进行规范化，包含将其大小变为：[369，680]，保存在标注规范数据文件夹中，并检测出针尖点位置，记录在针点数据文件里，行在前，列在后。
%created by zhangyan 2019-8-10;

clear
tr_dir='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\针点原图';
jpgstr = dir([tr_dir '\*.jpg']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
for i=1:fn
    imname1=strcat(tr_dir,'\',filenames{i});    
    im1=imread(imname1);
    imnn=imresize(im1, [369,680],'nearest');
    newdir='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\标注规范数据\';
    jiaozhengname=strcat(newdir,filenames{i});
    imwrite(uint8(imnn),jiaozhengname);
    imn=rgb2hsv(imnn);
    bw=roicolor(imn(:,:,1),0.155,0.165);
    [m,n]=size(imn(:,:,1));
    [xb,yb]=find(bw==1);
    xbm=mean(xb);
    ybm=mean(yb);
    newdir='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\针点数据\';
    reconame=strcat(newdir,filenames{i});
    reconame=strcat(reconame(1:end-3),'txt');
    fid=fopen(reconame,'w+');
    fprintf(fid,'%f\t%f',xbm,ybm);
    fclose(fid);    

 end

