d = dir('/usr/lib/lsl/mex/*.c');
for k=1:numel(d)
    mex('-llsl64','-ldl',['/usr/lib/lsl/mex/',d(k).name])
end
