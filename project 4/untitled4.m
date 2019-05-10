    im = imread('wt_slic.png');
    im = double(im);
    [m,n,~]=size(im);
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);
%     sz = m*n;

    S = 50;
    K = round((m*n) / (S*S));

    Center = zeros(K,5);
    label = -ones(m,n);
    distance = inf(m,n);
% 	queue = -ones{m*n};

    k=0;
	head=1;             %???
    tail=1;     
    for i = 1:round(m/S)
        for j = 1:round(n/S)
            k = k+1;
            Center(k,:)=[(i-1)*S + S/2,(j-1)*S + S/2,0,0,0];
            queue(1,head)= {[Center(k,1),Center(k,2),k,0]};
            head=head+1; 
        end
    end
    
    
    numk = K;

    kR = zeros(1,numk);
    kG = zeros(1,numk);
    kB = zeros(1,numk);
    kx = zeros(1,numk);
    ky = zeros(1,numk);
    ksize = zeros(1,numk);

    
    CONNECTIVITY = 4; %values can be 4 or 8
    M = 10;%compactness; %10.0;
    invwt = (M*M*numk)/(m*n);
    
%     qlength = head;
    pixelcount = 0;
    

    while(tail~=head)      
        x = queue{1,tail}(1);
        y = queue{1,tail}(2);
        k = queue{1,tail}(3);
%         [x,y,k,d] = queue(1,tail);
   
        tail = tail+1;
        if label(x,y) < 0 
        
            label(x,y) = k; 
            pixelcount = pixelcount +1;
            kR(1,k) = kR(1,k) + R(x,y);
            kG(1,k) = kG(1,k) + G(x,y);
            kB(1,k) = kB(1,k) + B(x,y);
            kx(1,k) = kx(1,k) + x;
            ky(1,k) = ky(1,k) + y;
            ksize(1,k) = ksize(1,k) + 1.0;
            
            for ii = -1:1  %connectivity = 8
                for jj = -1:1  
                    xx = x + ii;
                    yy = y + jj;
                    if ii~=0 || jj~=0
                        if xx >= 1 && xx < m && yy >= 1 && yy < n
%                             ii = yy * w + xx ;
                            if label(xx,yy) < 0  %//create new nodes
                                ldiff = kR(1,k) - R(xx,yy)*ksize(1,k);
                                adiff = kG(1,k) - G(xx,yy)*ksize(1,k);
                                bdiff = kB(1,k) - B(xx,yy)*ksize(1,k);
                                xdiff = kx(1,k) - xx*ksize(1,k);
                                ydiff = ky(1,k) - yy*ksize(1,k);

                                colordist   = ldiff*ldiff + adiff*adiff + bdiff*bdiff;
                                xydist      = xdiff*xdiff + ydiff*ydiff;
                                slicdist    = (colordist + xydist*invwt)/(ksize(1,k)*ksize(1,k));
        %                         //late normalization by ksize(k), to have only one division operation

                                queue(1,head)={[xx,yy,k,slicdist]};
                                head = head+1;
                            end
                        end
                    end
                end
            end
        end
       end         

%         if label(1,1) < 0 
%             label(1,1) = 0;
%         end
%         for y = 2:n
%             for x = 2:m
%                  i = y*m+x;
%                 if label(x,y) < 0
%                     if label(x-1,y) >= 0 
%                         label(x,y) = label(x-1,y);
%                     else label(x,y-1) >= 0 
%                         label(x,y) = label(x,y-1);
%                     end
%                 end
%             end
%         end
        for k=1:K
                for i=2:m-1
                    for j=1:n-1
                        if label(i,j) ~= label(i,j+1) || label(i,j) ~= label(i+1,j)
                            im(i,j,1)= 0;
                            im(i,j,2)= 0;
                            im(i,j,3)= 0;
                        end
                    end
                end
        end