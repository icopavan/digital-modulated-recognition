function issame = judge(type, rtype)

% 判断type和rtype是否代表同一种调制类型

if type(1) == 2
    type(1) = 'B';
elseif type(1) == 4
    type(1) = 'Q';
end

if rtype(1) == 2
    rtype(1) = 'B';
elseif rtype(1) == 4
    rtype(1) = 'Q';
end


if strcmpi(type, rtype)
    issame = 1;
else
    issame = 0;
end

end