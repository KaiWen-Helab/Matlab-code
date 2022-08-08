%程序说明：
%程序将标准图像旋转，使其与测试图像的边缘重合，并记录测试图像边缘位置，标准图像的位移，及旋转的角度。
%created by zhangyan 2019-8-10

clear
imname='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\standard.jpg';
im=imread(imname);
imn=rgb2hsv(im);
bw=roicolor(imn(:,:,1),0.155,0.165);
[m,n]=size(imn(:,:,1));
[xb,yb]=find(bw==1);
[mb,nb]=size(xb);
xbm=mean(xb(xb>0&xb<floor(m/2)));
xbxm=find(xb>0&xb<floor(m/2));
ybm=mean(yb(xbxm));
xba=mean(xb(xb>floor(m/2)&xb<m));
xbxa=find(xb>floor(m/2)&xb<m);
yba=mean(yb(xbxa));
standname='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\standard.txt';
fid=fopen(standname,'w+');
fprintf(fid,'%f\t%f\t%f\t%f',xbm,ybm,xba,yba);
fclose(fid);
tr_dir='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\规范化原图';
jpgstr = dir([tr_dir '\*.jpg']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
for i=1:fn
    imname1=strcat(tr_dir,'\',filenames{i});    
  
    im1=imread(imname1);
    imn1=rgb2hsv(im1);
    bw1=roicolor(imn1(:,:,1),0.155,0.165);
    [m1,n1]=size(imn1(:,:,1));
    [xb1,yb1]=find(bw1==1);
    [mb1,nb1]=size(xb1);
    xbm1=mean(xb1(xb1>0&xb1<floor(m1/2)));
    xbxm1=find(xb1>0&xb1<floor(m1/2));
    ybm1=mean(yb1(xbxm1));
    xba1=mean(xb1(xb1>floor(m1/2)&xb1<m1));
    xbxa1=find(xb1>floor(m1/2)&xb1<m1);
    yba1=mean(yb1(xbxa1));
    mnew=max(m,m+floor(xbm1-xbm));
    nnew=max(n,n+floor(ybm1-ybm ));
    im1new=zeros(mnew,nnew,3);
    for in=1:m
        for jn=1:n
            if in+floor((xbm1-xbm))>0 && jn+floor((ybm1-ybm))>0
                im1new(in+floor(xbm1-xbm),jn+floor(ybm1-ybm),:)=im(in,jn,:);
            end
        end
    end

    cx=xba+xbm1-xbm;
    cy=yba+ybm1-ybm;
    
    b2=(cx-xba1)^2+(cy-yba1)^2;
    a=sqrt((cx-xbm1)^2+(cy-ybm1)^2);
    c=sqrt((xba1-xbm1)^2+(yba1-ybm1)^2);
    pos=(a^2+c^2-b2)/(2*a*c);
    angle=acos(pos);
    if cy<yba1
        realangle=angle*180/pi;
        sign=1;
    else
        realangle=-angle*180/pi;
        sign=0;
    end
    point=[xbm1,ybm1];
    imnn=imrotatep(im1new,realangle,'bilinear','loose',point);

    newdir=strcat(tr_dir(1:end-5),'旋转后图像\');
    jiaozhengname=strcat(newdir,filenames{i});

    imwrite(uint8(imnn),jiaozhengname);
    newdir=strcat(tr_dir(1:end-5),'新校正数据\');
    reconame=strcat(newdir,filenames{i});
    reconame=strcat(reconame(1:end-3),'txt');
    fid=fopen(reconame,'w+');
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f',floor(xbm1-xbm),floor(ybm1-ybm),point(1),point(2),realangle,xba1,yba1);
    fclose(fid);
end

