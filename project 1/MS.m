function Idx  =  MS(data,radius,threshold)
%reference://blog.csdn.net/hjimce
%mean shift 
[m,n] = size(data);  
index = 1:m;   %cluster category
visit_record = zeros(m,1); % mark the visited point 
count = [];  
cluster_num = 0;  
cluster_center = [];  
  
while ~isempty(index)
    %choose a random point that didn't visited as a center
    center = data(index(ceil((length(index)-1e-6)*rand)),:);  
    visit_probability = zeros(m,1);%the probability of point visit
       
    while 1  
        %the inside points of the search window
        dis = sum((repmat(center,m,1) - data).^2,2);  
        innerS = find(dis<(radius*radius));
        visit_record(innerS) = 1; %record visited points 
        visit_probability(innerS) = visit_probability(innerS) + 1;  
        
        %compute the new center position 
        newcenter = zeros(1,n);  
        sumweight = 0;
        for i = 1:length(innerS)  
            w = exp(dis(innerS(i))/(radius*radius));  
            sumweight = w + sumweight;  
            newcenter = newcenter + w*data(innerS(i),:);  
        end  
        newcenter = newcenter./sumweight;  
  
        % if the moving distance less than threshold, stop
        if norm(newcenter - center) <threshold
            break;  
        end  
        center = newcenter;  
          
    end
    
    % determine if the new center need to merge, if not?the number of clusters + 1
    merge = 0;
    for i = 1:cluster_num   
        if norm(center - cluster_center(i,:)) < radius/2  
             merge = i;   
             break;
        end  
    end 
    
    if merge == 0        % a new cluster 
        cluster_num = cluster_num + 1;  
        cluster_center(cluster_num,:) = center;
        count(:,cluster_num) = visit_probability;  
    else                 % merge
        cluster_center(merge,:) = 0.5*(cluster_center(merge,:) + center);  
        count(:,merge) = count(:,merge) + visit_probability;    
    end
    
    %recount points that have not been visited
    index = find(visit_record == 0);  
end 
  
%the result of cluster
for i = 1:m  
    [~, index] = max(count(i,:));  
    Idx(i) = index;
end

end
  

