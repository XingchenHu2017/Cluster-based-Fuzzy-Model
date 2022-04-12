function y = partition_matrix( center, data, m )
%entries of the partition matrix
out = zeros(size(center, 1), size(data, 1));
% fill the output matrix
if size(center, 2) > 1,
    for k = 1:size(center, 1),
	out(k, :) = sqrt(sum((((data-ones(size(data, 1), 1)*center(k, :))./(ones(size(data, 1), 1)*std(data))).^2)'));
%         out(k, :) = sqrt(sum(((data-ones(size(data, 1), 1)*center(k, :)).^2)'));
    end
else	% 1-D data
    for k = 1:size(center, 1),
	out(k, :) = abs(center(k)-data)';
    end
end
tmp = out.^(-2/(m-1));
y = tmp./(ones(size(center,1), 1)*sum(tmp));
end

