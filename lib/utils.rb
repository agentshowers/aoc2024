module Utils
  # Solves equation system like this one
  # a1*x + b1*y = c1
  # a2*x + b2*y = c2
  def cramer_rule(a1, b1, c1, a2, b2, c2)
    a = (1.0*(c1*b2) - (b1*c2))/((a1*b2) - (b1*a2))
    b = (1.0*(c2*a1) - (a2*c1))/((a1*b2) - (b1*a2))
    [a, b]
  end
end
