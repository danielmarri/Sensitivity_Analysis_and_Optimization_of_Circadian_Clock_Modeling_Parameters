% create correlated sequence


R1 = randn(100,1);
R2 = randn(100,1);
R3 = randn(100,1);

rho = 0.6;
for i = 2:100
    R1(i) = R1(i-1)*rho + R2(i)*sqrt(1-rho^2);
end

rk = AMIGO_autocorrelation([R1 R3],8);