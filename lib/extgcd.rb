def extgcd(a, b)
  return [0, 1, b] if a == 0
  return [1, 0, a] if a == b || b == 0
  i, j, gcd = extgcd a % b, b % a
  [i - b / a * j, j - a / b * i, gcd]
end

a, b, c = 42, 15, 900
x, y, gcd = extgcd a, b
raise unless c % gcd == 0
n = c / gcd
an = x * n - b * (x * n / b)
bn = y * n + a * (x * n / b)
an * a + bn * b == c # with minimum an>=0 and maximum bn
