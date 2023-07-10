function [data height width frame] = read_movie_data_noreshape_selected(filename, idx)
load(filename);
source_data = ImData;

data = [];
for j = 1:length(idx)
    i = idx(j);
    
    %im = imresize(source_data(:,:,i),0.5);
    im = source_data(:,:,i);
    data = cat(3, data, im);
end
soure_data = [];
ImData = [];
[height width frame] =  size(data)