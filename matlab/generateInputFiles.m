function generateInputFiles()

    % Parameters
    numValues = 100; % Adjust as needed
    precision = 5; % Number of decimal places

    % Generate random floating-point values for A and save to file
    A = randn(1, numValues);
    writeFloatingPointFile('A.txt', A, precision);

    % Generate random floating-point values for B and save to file
    B = randn(1, numValues);
    writeFloatingPointFile('B.txt', B, precision);

    % Calculate A/B and save to file
    result = A ./ B;
    writeFloatingPointFile('result.txt', result, precision);

    % Convert floating-point values to IEEE754 32-bit format and save to files
    convertAndSaveIEEE754('A_ieee754.txt', A);
    convertAndSaveIEEE754('B_ieee754.txt', B);
    convertAndSaveIEEE754('result_ieee754.txt', result);

end

function writeFloatingPointFile(filename, data, precision)
    fid = fopen(filename, 'w');
    fprintf(fid, '%.*f\n', precision, data);
    fclose(fid);
end

function convertAndSaveIEEE754(filename, data)
    ieee754 = typecast(single(data), 'uint32');
    fid = fopen(filename, 'w');
    fprintf(fid, '%08X\n', ieee754);
    fclose(fid);
end
