left= [];
x_feed= 0; % initialize

if mean(xpos- x_feed)>0
    left= 1; % eye is moving leftwards
else
    left= 0; % eye is moving rightwards
end

% keep track of previous samples:
x_feed= [x_feed, xpos];

% keep feed from growing infinitely large:
if length(x_feed)>10 % cut off sample feed at 10
    x_feed= x_feed(2:11);
end

