## Extended Standard Library for Godot - Never Re-Invent the Wheel Again!
##
## A comprehensive utility library providing math, financial calculations,
## encryption, paradoxes, quantum mechanics, game dev helpers, and more.
##
## [b]Features include:[/b]
## - Financial math (compound interest, loan amortization, NPV, Black-Scholes)
## - Paradox simulations (Birthday, Monty Hall, Simpson's, etc.)
## - Quantum/physics calculations (time dilation, tunneling, Mandelbrot)
## - Encryption utilities (XOR, substitution ciphers, file encryption)
## - Game dev helpers (screen shake, input vectors, scene management)
## - String, array, color, and time utilities
##
## [b]Usage:[/b] Simply call any function with [code]stde.function_name()[/code]
##
## [b]Example:[/b]
## [codeblock]
## var interest = stde.compound_intrst(1000, 5, 2, 12)
## stde.create_screen_shake_simple(self, 10.0, 0.5)
## var prob = stde.birthday_paradox(23)  # ~50% chance!
## [/codeblock]
class_name stde
extends Node

#region Math & Financial Utilities

## Returns the maximum of a value and a minimum threshold.
## Useful for clamping values to a minimum without an upper bound.
##
## [codeblock]
## var health = stde.clamp_min(player_health, 0)  # Health can't go below 0
## [/codeblock]
##
## [param value] The value to clamp
## [param min] The minimum threshold
## [return] The clamped value (at least [param min])
@warning_ignore("shadowed_global_identifier")
static func clamp_min(value, min):
	return max(value, min)

## Returns the minimum of a value and a maximum threshold.
## Useful for clamping values to a maximum without a lower bound.
##
## [codeblock]
## var speed = stde.clamp_max(player_speed, 100)  # Speed can't exceed 100
## [/codeblock]
##
## [param value] The value to clamp
## [param max] The maximum threshold
## [return] The clamped value (at most [param max])
@warning_ignore("shadowed_global_identifier")
static func clamp_max(value, max):
	return min(value, max)

## Calculates integer power efficiently without floating point operations.
## Raises [param val] to the power of [param expo] using only integer math.
##
## [b]Note:[/b] Does not support negative exponents. Use [code]pow()[/code] for that.
##
## [codeblock]
## var result = stde.powi(2, 10)  # 1024
## var cube = stde.powi(5, 3)     # 125
## [/codeblock]
##
## [param val] The base value
## [param expo] The exponent (must be >= 0)
## [return] [param val] raised to the power of [param expo]
static func powi(val: int, expo: int) -> int:
	if expo == 0:
		return 1
	elif expo < 0:
		push_error("powi: Negative exponents not supported for integer power. Use pow() instead.")
		return 0
	elif val == 0:
		return 0
	
	var result = 1
	for i in range(expo):
		result *= val
	
	return result

## Returns the square of a value (val * val).
## Faster than using [code]pow(val, 2)[/code] for simple squaring.
##
## [codeblock]
## var distance_squared = stde.sqr(dx) + stde.sqr(dy)  # Avoid sqrt for distance checks
## [/codeblock]
##
## [param val] The value to square
## [return] The square of [param val]
static func sqr(val):
	if val == null:
		push_error("sqr: Value cannot be null")
		return 0
	return val * val

## Returns the cube of a value (val * val * val).
## Useful for volume calculations or cubic functions.
##
## [codeblock]
## var volume = stde.cube(side_length)  # Volume of a cube
## [/codeblock]
##
## [param val] The value to cube
## [return] The cube of [param val]
static func cube(val):
	if val == null:
		push_error("cube: Value cannot be null")
		return 0
	return val * val * val

## Rounds a value to the nearest increment.
## Useful for grid snapping, price rounding, or discrete value systems.
##
## [codeblock]
## var price = stde.round_inc(24.99, 5)    # 25.0 (nearest $5)
## var grid_pos = stde.round_inc(127, 32)  # 128 (snap to 32-unit grid)
## [/codeblock]
##
## [param val] The value to round
## [param increment] The increment to round to (must be positive)
## [return] The value rounded to the nearest [param increment]
static func round_inc(val, increment):
	if increment == 0:
		return val
	elif increment < 0:
		push_error("round_inc: Increment cannot be negative")
		return val
	return round(val / increment) * increment

## Checks if a number is prime using the 6k±1 optimization.
## Returns true if the number is prime, false otherwise.
##
## Uses an efficient algorithm that checks divisibility by 2 and 3,
## then tests numbers of the form 6k±1 up to sqrt(val).
##
## [codeblock]
## if stde.is_prime(7919):
##     print("It's prime!")  # True
## [/codeblock]
##
## [param val] The integer to test
## [return] True if [param val] is prime, false otherwise
static func is_prime(val: int) -> bool:
	if val == null:
		push_error("is_prime: Value cannot be null")
		return false
	if val <= 1:
		return false
	if val <= 3:
		return true
	if val % 2 == 0 or val % 3 == 0:
		return false
	var i = 5
	while i * i <= val:
		if val % i == 0 or val % (i + 2) == 0:
			return false
		i += 6
	return true

## Maps a value from one range to another (lerp between ranges).
## Essential for converting values between different scales.
##
## [codeblock]
## # Convert joystick input (-1 to 1) to rotation (0 to 360)
## var rotation = stde.map(joystick_x, -1, 1, 0, 360)
##
## # Convert health (0-100) to UI bar width (0-200 pixels)
## var bar_width = stde.map(health, 0, 100, 0, 200)
## [/codeblock]
##
## [param value] The value to map
## [param from_min] Minimum of the input range
## [param from_max] Maximum of the input range
## [param to_min] Minimum of the output range
## [param to_max] Maximum of the output range
## [return] The mapped value in the output range
static func map(value, from_min, from_max, to_min, to_max):
	if from_max == from_min:
		return (to_min + to_max) / 2.0
	return to_min + ((value - from_min) / (from_max - from_min)) * (to_max - to_min)

## Calculates simple interest using the formula: SI = (P * R * T) / 100
## Simple interest doesn't compound - it's a fixed percentage per period.
##
## [codeblock]
## # $1000 at 5% for 3 years
## var interest = stde.simple_intrst(1000, 5, 3)
## print(interest)  # 150.0
## [/codeblock]
##
## [param princ] Principal amount (initial investment)
## [param rate] Annual interest rate as percentage (e.g., 5 for 5%)
## [param time] Time period in years
## [return] The simple interest earned
static func simple_intrst(princ, rate, time):
	if princ == null or rate == null or time == null:
		push_error("simple_intrst: Arguments are missing!")
		return 0
	
	if princ <= 0 or rate <= 0 or time <= 0:
		push_warning("Interest calculation with non-positive values may not make sense")
	
	var si = (princ * rate * time) / 100
	return si

## Calculates compound interest with flexible compounding periods.
## Returns only the interest earned, not the total amount.
##
## Formula: A = P(1 + r/100)^n, where n = time/compounded_every
##
## [codeblock]
## # $1000 at 5% for 2 years, compounded monthly
## var interest = stde.compound_intrst(1000, 5, 2, 1.0/12.0)
## print(interest)  # Interest earned after 2 years
##
## # Quarterly compounding
## var quarterly = stde.compound_intrst(1000, 5, 2, 0.25)
## [/codeblock]
##
## [param princ] Principal amount (initial investment)
## [param rate] Annual interest rate as percentage (e.g., 5 for 5%)
## [param time] Time period in years
## [param compounded_every] Compounding frequency in years (e.g., 1.0/12.0 for monthly, 0.25 for quarterly)
## [return] The compound interest earned (not including principal)
static func compound_intrst(princ, rate, time: float , compounded_every: float):
	if princ == null or rate == null or time == null or compounded_every == null:
		push_error("compound_intrst: Arguments are missing!")
		return 0
	
	if princ <= 0 or rate <= 0 or time <= 0 or compounded_every <= 0:
		push_warning("Compound interest calculation with non-positive values may not make sense")
		return 0
	
	princ = float(princ)
	rate = float(rate)
	var n
	var x = float(clamp_min(round_inc(clamp_max(compounded_every, 4), 0.5), 1))
	compounded_every = x
	n = time / compounded_every
	var a = float(float(princ) * float(pow((1 + (rate/100)), n)))
	var result = a - princ
	return result

## Calculates the cube root of a value.
## Handles negative numbers correctly (unlike pow(val, 1/3)).
##
## [codeblock]
## var side = stde.cubrt(27)   # 3.0
## var neg = stde.cubrt(-8)    # -2.0 (handles negatives!)
## [/codeblock]
##
## [param val] The value to find the cube root of
## [return] The cube root of [param val]
static func cubrt(val: float) -> float:
	if val == null:
		push_error("cubrt: Value cannot be null")
		return 0.0
	if val < 0:
		return -pow(-val, 1.0/3.0)
	return pow(val, 1.0/3.0)

## Converts a percentage to decimal (50% → 0.5).
## Automatically clamps input to 0-100 range.
##
## [codeblock]
## var multiplier = stde.per_to_dec(75)  # 0.75
## var damage = base_damage * multiplier
## [/codeblock]
##
## [param val] Percentage value (0-100)
## [return] Decimal representation (0.0-1.0)
static func per_to_dec(val: float):
	if val == null:
		push_error("per_to_dec: Value cannot be null")
		return 0.0
	val = clampf(val, 0, 100)
	if val == 0:
		return 0
	var a = val / 100
	return a

## Converts a decimal to percentage (0.5 → 50%).
## Automatically clamps output to 0-100 range.
##
## [codeblock]
## var percent = stde.dec_to_per(0.75)  # 75.0
## print(str(percent) + "%")
## [/codeblock]
##
## [param val] Decimal value
## [return] Percentage representation (0.0-100.0)
static func dec_to_per(val: float):
	if val == null:
		push_error("dec_to_per: Value cannot be null")
		return 0.0
	var a = clamp((val * 100), 0, 100)
	if val == 0:
		return 0
	return a

## Wraps an angle to the range [-PI, PI] (or [-180°, 180°] in degrees).
## Useful for normalizing rotation values.
##
## [codeblock]
## var normalized = stde.wrap_angle(deg_to_rad(380))  # Wraps to 20°
## [/codeblock]
##
## [param angle] The angle in radians
## [return] The wrapped angle in the range [-PI, PI]
static func wrap_angle(angle):
	if angle == null:
		push_error("wrap_angle: Angle cannot be null")
		return 0.0
	return fmod(angle + PI, 2 * PI) - PI

## Calculates the Euclidean distance between two 2D points.
## More efficient than using Vector2.distance_to() in some contexts.
##
## [codeblock]
## var dist = stde.distance2d(player_pos, enemy_pos)
## if dist < 100:
##     print("Enemy nearby!")
## [/codeblock]
##
## [param a] First point (Vector2)
## [param b] Second point (Vector2)
## [return] The distance between the two points
static func distance2d(a, b):
	if a == null or b == null:
		push_error("distance2d: Points cannot be null")
		return 0.0
	if not (a is Vector2) or not (b is Vector2):
		push_error("distance2d: Points must be Vector2")
		return 0.0
	return sqrt(sqr(a.x - b.x) + sqr(a.y - b.y))

#endregion

#region Complex Numbers

## Multiplies two complex numbers together.
## Complex numbers are represented as [real, imaginary] arrays.
##
## Formula: (a + bi)(c + di) = (ac - bd) + (ad + bc)i
##
## [codeblock]
## var result = stde.complex_multiply(3, 4, 1, 2)  # (3+4i) * (1+2i)
## print(result)  # [-5.0, 10.0] which is -5 + 10i
## [/codeblock]
##
## [param a_real] Real part of first number
## [param a_imag] Imaginary part of first number
## [param b_real] Real part of second number
## [param b_imag] Imaginary part of second number
## [return] Array [real, imaginary] representing the result
static func complex_multiply(a_real: float, a_imag: float, b_real: float, b_imag: float) -> Array:
	if a_real == null or a_imag == null or b_real == null or b_imag == null:
		push_error("complex_multiply: Arguments cannot be null")
		return [0.0, 0.0]
	var real = a_real * b_real - a_imag * b_imag
	var imag = a_real * b_imag + a_imag * b_real
	return [real, imag]

## Raises a complex number to a real power.
## Uses polar form conversion for accurate results.
##
## [codeblock]
## # (3+4i)^2
## var result = stde.complex_power(3, 4, 2)
## print(result)  # [-7.0, 24.0] = -7 + 24i
## [/codeblock]
##
## [param real] Real part of the complex number
## [param imag] Imaginary part of the complex number
## [param power] The exponent (real number)
## [return] Array [real, imaginary] representing the result
static func complex_power(real: float, imag: float, power: float) -> Array:
	if real == null or imag == null or power == null:
		push_error("complex_power: Arguments cannot be null")
		return [0.0, 0.0]
	var r = sqrt(real * real + imag * imag)
	var theta = atan2(imag, real)
	var new_r = pow(r, power)
	var new_theta = theta * power
	return [new_r * cos(new_theta), new_r * sin(new_theta)]

## Returns the magnitude (absolute value) of a complex number.
## This is the distance from the origin in the complex plane.
##
## [codeblock]
## var mag = stde.complex_magnitude(3, 4)  # 5.0
## [/codeblock]
##
## [param real] Real part
## [param imag] Imaginary part
## [return] The magnitude (|z| = sqrt(real² + imag²))
static func complex_magnitude(real: float, imag: float) -> float:
	if real == null or imag == null:
		push_error("complex_magnitude: Arguments cannot be null")
		return 0.0
	return sqrt(real * real + imag * imag)

## Returns the complex conjugate (flips the sign of the imaginary part).
## Used in division and for finding real parts of products.
##
## [codeblock]
## var conj = stde.complex_conjugate(3, 4)  # [3, -4] = 3 - 4i
## [/codeblock]
##
## [param real] Real part
## [param imag] Imaginary part
## [return] Array [real, -imaginary]
static func complex_conjugate(real: float, imag: float) -> Array:
	if real == null or imag == null:
		push_error("complex_conjugate: Arguments cannot be null")
		return [0.0, 0.0]
	return [real, -imag]

#endregion

#region New Vector Math

## Calculates the angle between two vectors in radians.
## Returns values from 0 to PI (0° to 180°).
##
## [codeblock]
## var angle = stde.angle_between_vectors(Vector2.RIGHT, Vector2.UP)
## print(rad_to_deg(angle))  # 90.0 degrees
## [/codeblock]
##
## [param a] First vector
## [param b] Second vector
## [return] Angle between vectors in radians (0 to PI)
static func angle_between_vectors(a: Vector2, b: Vector2) -> float:
	if a == null or b == null:
		push_error("angle_between_vectors: Vectors cannot be null")
		return 0.0
	var a_len = a.length()
	var b_len = b.length()
	if a_len == 0 or b_len == 0:
		push_error("angle_between_vectors: Zero-length vectors not allowed")
		return 0.0
	return acos(a.dot(b) / (a_len * b_len))

## Rotates a 2D vector by a given angle (in radians).
## More efficient than using Transform2D for simple rotation.
##
## [codeblock]
## var rotated = stde.vec2_rotate(Vector2.RIGHT, PI/2)  # Rotate 90°
## print(rotated)  # Approximately Vector2.UP
## [/codeblock]
##
## [param v] The vector to rotate
## [param angle] Rotation angle in radians (positive = counterclockwise)
## [return] The rotated vector
static func vec2_rotate(v: Vector2, angle: float) -> Vector2:
	if v == null or angle == null:
		push_error("vec2_rotate: Arguments cannot be null")
		return Vector2.ZERO
	var cos_a = cos(angle)
	var sin_a = sin(angle)
	return Vector2(v.x * cos_a - v.y * sin_a, v.x * sin_a + v.y * cos_a)

#endregion

#region Numerical Methods

## Calculates the numerical derivative of a function at a point.
## Uses central difference method for better accuracy.
##
## [codeblock]
## var f = func(x): return x * x  # f(x) = x²
## var slope = stde.derivative(f, 3.0)  # df/dx at x=3
## print(slope)  # ~6.0 (exact derivative of x² at x=3 is 2x = 6)
## [/codeblock]
##
## [param func_ref] Callable function to differentiate
## [param x] Point at which to evaluate the derivative
## [param h] Step size (smaller = more accurate but less stable)
## [return] Approximate derivative at x
static func derivative(func_ref: Callable, x: float, h: float = 0.0001) -> float:
	if func_ref == null or x == null or h == null:
		push_error("derivative: Arguments cannot be null")
		return 0.0
	if h <= 0:
		push_error("derivative: Step size h must be positive")
		return 0.0
	return (func_ref.call(x + h) - func_ref.call(x - h)) / (2.0 * h)

## Calculates definite integral using Simpson's rule.
## More accurate than basic rectangle or trapezoid methods.
##
## [codeblock]
## var f = func(x): return x * x  # Integrate x² from 0 to 2
## var area = stde.integrate_simpson(f, 0, 2, 100)
## print(area)  # ~2.667 (exact: 8/3)
## [/codeblock]
##
## [param func_ref] Function to integrate
## [param a] Lower bound
## [param b] Upper bound
## [param n] Number of subdivisions (higher = more accurate, must be even)
## [return] Approximate definite integral
static func integrate_simpson(func_ref: Callable, a: float, b: float, n: int = 100) -> float:
	if func_ref == null or a == null or b == null or n == null:
		push_error("integrate_simpson: Arguments cannot be null")
		return 0.0
	if n < 2:
		push_error("integrate_simpson: n must be at least 2")
		return 0.0
	if a >= b:
		push_error("integrate_simpson: a must be less than b")
		return 0.0
	
	if n % 2 != 0: n += 1
	var h = (b - a) / n
	var sum = func_ref.call(a) + func_ref.call(b)
	
	for i in range(1, n):
		var x = a + i * h
		sum += (2.0 if i % 2 == 0 else 4.0) * func_ref.call(x)
	
	return sum * h / 3.0

## Finds a root of a function using Newton's method.
## Requires both the function and its derivative.
##
## [codeblock]
## var f = func(x): return x*x - 4  # Solve x² - 4 = 0
## var df = func(x): return 2*x     # Derivative: 2x
## var root = stde.find_root_newton(f, df, 1.0)  # Initial guess: 1
## print(root)  # ~2.0 (solution to x² = 4)
## [/codeblock]
##
## [param func_ref] The function to find the root of
## [param derivative_ref] The derivative of the function
## [param initial_guess] Starting point for iteration
## [param max_iterations] Maximum number of iterations
## [param tolerance] Convergence threshold
## [return] Approximate root of the function
static func find_root_newton(func_ref: Callable, derivative_ref: Callable, initial_guess: float, 
						   max_iterations: int = 100, tolerance: float = 1e-10) -> float:
	if func_ref == null or derivative_ref == null or initial_guess == null:
		push_error("find_root_newton: Arguments cannot be null")
		return 0.0
	if max_iterations <= 0:
		push_error("find_root_newton: max_iterations must be positive")
		return initial_guess
	if tolerance <= 0:
		push_error("find_root_newton: tolerance must be positive")
		return initial_guess
	
	var x = initial_guess
	for i in range(max_iterations):
		var fx = func_ref.call(x)
		var dfx = derivative_ref.call(x)
		
		if abs(dfx) < tolerance:
			if abs(fx) < tolerance:
				return x
			else:
				push_warning("find_root_newton: Derivative near zero, cannot continue. Current guess: " + str(x))
				return x
		
		var x_new = x - fx / dfx
		if abs(x_new - x) < tolerance:
			if abs(func_ref.call(x_new)) < tolerance:
				return x_new
			else:
				push_warning("find_root_newton: Convergence to non-root. Result may be inaccurate.")
				return x_new
		x = x_new
	if abs(func_ref.call(x)) < tolerance:
		return x
	else:
		push_warning("find_root_newton: Maximum iterations reached without convergence")
		return x

#endregion

#region Advanced Geometry

## Calculates triangle area using Heron's formula.
## Works with side lengths only (no coordinates needed).
##
## [codeblock]
## var area = stde.triangle_area_heron(3, 4, 5)  # Right triangle
## print(area)  # 6.0
## [/codeblock]
##
## [param a] Length of first side
## [param b] Length of second side
## [param c] Length of third side
## [return] Area of the triangle
static func triangle_area_heron(a: float, b: float, c: float) -> float:
	var s = (a + b + c) / 2.0
	return sqrt(s * (s - a) * (s - b) * (s - c))

## Calculates triangle area from three 2D points.
## Uses the cross product method (shoelace formula).
##
## [codeblock]
## var area = stde.triangle_area_points(
##     Vector2(0, 0), 
##     Vector2(4, 0), 
##     Vector2(0, 3)
## )
## print(area)  # 6.0
## [/codeblock]
##
## [param a] First vertex
## [param b] Second vertex
## [param c] Third vertex
## [return] Area of the triangle
static func triangle_area_points(a: Vector2, b: Vector2, c: Vector2) -> float:
	return abs((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2.0)

## Calculates the shortest distance from a point to a line segment.
## Useful for collision detection and proximity checks.
##
## [codeblock]
## var dist = stde.distance_point_to_line(
##     player_pos, 
##     wall_start, 
##     wall_end
## )
## if dist < 10:
##     print("Too close to wall!")
## [/codeblock]
##
## [param point] The point to measure from
## [param line_start] Start of the line segment
## [param line_end] End of the line segment
## [return] Shortest distance from point to line segment
static func distance_point_to_line(point: Vector2, line_start: Vector2, line_end: Vector2) -> float:
	var line_vec = line_end - line_start
	var point_vec = point - line_start
	var line_length_squared = line_vec.length_squared()
	if line_length_squared == 0: return point_vec.length()
	var t = max(0, min(1, point_vec.dot(line_vec) / line_length_squared))
	var projection = line_start + t * line_vec
	return point.distance_to(projection)

#endregion

#region Advanced Financial Math

## Calculates loan amortization schedule with payment breakdown.
## Returns monthly payment, total interest, and full payment schedule.
##
## [codeblock]
## # $200,000 loan at 4.5% for 30 years
## var loan = stde.loan_amortization(200000, 4.5, 30)
## print("Monthly payment: $", loan.monthly_payment)
## print("Total interest: $", loan.total_interest)
## print("First payment breakdown: ", loan.schedule[0])
## [/codeblock]
##
## [param principal] Loan amount
## [param annual_rate] Annual interest rate as percentage (e.g., 4.5 for 4.5%)
## [param years] Loan term in years
## [param payments_per_year] Number of payments per year (default 12 for monthly)
## [return] Dictionary with monthly_payment, total_interest, and schedule array
static func loan_amortization(principal: float, annual_rate: float, years: int, payments_per_year: int = 12) -> Dictionary:
	var monthly_rate = annual_rate / 100.0 / payments_per_year
	var total_payments = years * payments_per_year
	var monthly_payment = principal * (monthly_rate * pow(1 + monthly_rate, total_payments)) / (pow(1 + monthly_rate, total_payments) - 1)
	
	var schedule = []
	var balance = principal
	
	for payment_num in range(1, total_payments + 1):
		var interest_payment = balance * monthly_rate
		var principal_payment = monthly_payment - interest_payment
		balance -= principal_payment
		
		schedule.append({
			"payment": payment_num,
			"payment_amount": monthly_payment,
			"interest": interest_payment,
			"principal": principal_payment,
			"balance": balance
		})
	
	return {
		"monthly_payment": monthly_payment,
		"total_interest": monthly_payment * total_payments - principal,
		"schedule": schedule
	}

## Calculates Net Present Value (NPV) of a series of cash flows.
## Used to evaluate investment opportunities by discounting future cash flows.
##
## [codeblock]
## # Investment: -1000 initial, then +300 per year for 4 years
## var cash_flows = [-1000, 300, 300, 300, 300]
## var npv = stde.net_present_value(cash_flows, 0.1)  # 10% discount rate
## if npv > 0:
##     print("Good investment!")  # Positive NPV means profitable
## [/codeblock]
##
## [param cash_flows] Array of cash flows (negative = outflow, positive = inflow)
## [param discount_rate] Discount rate as decimal (e.g., 0.1 for 10%)
## [return] Net present value
static func net_present_value(cash_flows: Array, discount_rate: float) -> float:
	var npv = 0.0
	for i in range(cash_flows.size()):
		npv += cash_flows[i] / pow(1 + discount_rate, i)
	return npv

## Calculates Internal Rate of Return (IRR) using Newton's method.
## IRR is the discount rate that makes NPV equal to zero.
##
## [codeblock]
## var cash_flows = [-1000, 300, 400, 500]
## var irr = stde.internal_rate_return(cash_flows)
## print("IRR: ", irr * 100, "%")  # Convert to percentage
## [/codeblock]
##
## [param cash_flows] Array of cash flows
## [param max_iterations] Maximum iterations for convergence
## [param tolerance] Convergence threshold
## [return] Internal rate of return as decimal
static func internal_rate_return(cash_flows: Array, max_iterations: int = 1000, tolerance: float = 0.0001) -> float:
	var guess = 0.1
	for iteration in range(max_iterations):
		var npv = 0.0
		@warning_ignore("shadowed_variable")
		var derivative = 0.0
		
		for t in range(cash_flows.size()):
			npv += cash_flows[t] / pow(1 + guess, t)
			derivative -= t * cash_flows[t] / pow(1 + guess, t + 1)
		
		if abs(npv) < tolerance:
			return guess
		
		if abs(derivative) < 0.000001:
			break
			
		guess -= npv / derivative
	
	return guess

## Calculates Black-Scholes option price for European call options.
## Industry-standard model for pricing stock options.
##
## [b]Note:[/b] This is for educational/simulation purposes. Real trading
## requires professional financial advice.
##
## [codeblock]
## # Price a call option:
## var price = stde.black_scholes_call_price(
##     100,    # Stock price: $100
##     105,    # Strike price: $105
##     0.25,   # Time to expiry: 3 months (0.25 years)
##     0.05,   # Risk-free rate: 5%
##     0.2     # Volatility: 20%
## )
## print("Option price: $", price)
## [/codeblock]
##
## [param S] Current stock price
## [param K] Strike price
## [param T] Time to expiration in years
## [param r] Risk-free interest rate as decimal
## [param sigma] Volatility (standard deviation) as decimal
## [return] Call option price
static func black_scholes_call_price(S: float, K: float, T: float, r: float, sigma: float) -> float:
	var d1 = (log(S / K) + (r + 0.5 * sigma * sigma) * T) / (sigma * sqrt(T))
	var d2 = d1 - sigma * sqrt(T)
	return S * norm_cdf(d1) - K * exp(-r * T) * norm_cdf(d2)

## Cumulative distribution function for standard normal distribution.
## Helper function for Black-Scholes calculations.
##
## [param x] Input value
## [return] Probability that a standard normal variable is less than x
static func norm_cdf(x: float) -> float:
	return 0.5 * (1 + erf(x / sqrt(2)))

## Error function approximation using Abramowitz and Stegun method.
## Helper function for statistical calculations.
##
## [param x] Input value
## [return] Error function value
static func erf(x: float) -> float:
	var a1 =  0.254829592
	var a2 = -0.284496736
	var a3 =  1.421413741
	var a4 = -1.453152027
	var a5 =  1.061405429
	var p  =  0.3275911
	
	@warning_ignore("shadowed_global_identifier")
	var sign = 1 if x >= 0 else -1
	x = abs(x)
	var t = 1.0 / (1.0 + p * x)
	var y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x)
	return sign * y

## Quick approximation for doubling time using the Rule of 72.
## Estimates years needed to double an investment.
##
## [codeblock]
## var years = stde.rule_of_72(8)  # 8% annual return
## print("Doubles in ~", years, " years")  # ~9 years
## [/codeblock]
##
## [param rate] Annual interest rate as percentage
## [return] Approximate years to double
static func rule_of_72(rate: float) -> float:
	return 72.0 / rate

## Calculates continuous compound interest (e^rt formula).
## Used in theoretical finance and some real-world applications.
##
## [codeblock]
## var final_amount = stde.continuous_compound(1000, 5, 10)
## print("After 10 years: $", final_amount)
## [/codeblock]
##
## [param principal] Initial amount
## [param rate] Annual interest rate as percentage
## [param time] Time in years
## [return] Final amount with continuous compounding
static func continuous_compound(principal: float, rate: float, time: float) -> float:
	return principal * exp(rate * time / 100.0)

#endregion

#region Paradoxes & Counterintuitive Maths

## Calculates the probability of shared birthdays in a group.
## Famous paradox: With just 23 people, there's a 50% chance of a match!
##
## [codeblock]
## print(stde.birthday_paradox(23))  # ~0.507 (50.7%!)
## print(stde.birthday_paradox(50))  # ~0.970 (97%!)
## print(stde.birthday_paradox(70))  # ~0.999 (99.9%!)
## [/codeblock]
##
## [param people] Number of people in the group
## [param days_in_year] Days in year (default 365)
## [return] Probability of at least one shared birthday (0.0 to 1.0)
static func birthday_paradox(people: int, days_in_year: int = 365) -> float:
	var prob_no_match = 1.0
	for i in range(people):
		prob_no_match *= float(days_in_year - i) / float(days_in_year)
	return 1.0 - prob_no_match

## Simulates the Monty Hall problem to prove switching wins 67% of the time.
##
## The famous game show paradox: You pick one of three doors (one has a car,
## two have goats). The host, who knows what's behind each door, opens a
## different door revealing a goat. Should you switch to the remaining door?
##
## [b]Counterintuitively, switching wins ~67% of the time![/b]
##
## [codeblock]
## var switch_rate = stde.monty_hall_simulation(true, 10000)
## var stay_rate = stde.monty_hall_simulation(false, 10000)
## print("Switch wins: ", switch_rate * 100, "%")  # ~67%
## print("Stay wins: ", stay_rate * 100, "%")      # ~33%
## [/codeblock]
##
## [param switch_doors] If true, player switches after host reveals a door
## [param simulations] Number of games to simulate (higher = more accurate)
## [return] Win rate as float between 0.0 and 1.0
static func monty_hall_simulation(switch_doors: bool, simulations: int = 10000) -> float:
	var wins = 0
	for i in range(simulations):
		var car_behind = randi() % 3
		var player_choice = randi() % 3
		
		var reveal_options = []
		for door in range(3):
			if door != player_choice and door != car_behind:
				reveal_options.append(door)
		var revealed = reveal_options[randi() % reveal_options.size()]
		
		var final_choice
		if switch_doors:
			for door in range(3):
				if door != player_choice and door != revealed:
					final_choice = door
					break
		else:
			final_choice = player_choice
		
		if final_choice == car_behind:
			wins += 1
	
	return float(wins) / simulations

## Returns the expected frequency of a leading digit according to Benford's Law.
## Real-world data often follows this counterintuitive distribution!
##
## Benford's Law states that in many naturally occurring datasets,
## the digit 1 appears as the leading digit about 30% of the time,
## while 9 appears only about 5% of the time.
##
## [codeblock]
## for digit in range(1, 10):
##     var freq = stde.benfords_law(digit)
##     print("Digit ", digit, ": ", freq * 100, "%")
## # 1: 30.1%, 2: 17.6%, 3: 12.5%... 9: 4.6%
## [/codeblock]
##
## [param digit] Leading digit (1-9)
## [return] Expected frequency (0.0 to 1.0)
static func benfords_law(digit: int) -> float:
	if digit < 1 or digit > 9:
		return 0.0
	return log(1.0 + 1.0 / digit) / log(10.0)

## Demonstrates Simpson's Paradox with example data.
## A trend can reverse when data is combined!
##
## This returns example data showing how treatment can appear worse than
## control in each subgroup, yet better overall when groups are combined.
## A classic statistical trap in data analysis.
##
## [codeblock]
## var demo = stde.simpsons_paradox_demo()
## print("Group A: Treatment better? ", demo.group_a_treatment_rate > demo.group_a_control_rate)
## print("Group B: Treatment better? ", demo.group_b_treatment_rate > demo.group_b_control_rate)
## print("Combined: Treatment better? ", demo.combined_treatment_rate > demo.combined_control_rate)
## print("Paradox occurs: ", demo.paradox_occurs)  # Can be true!
## [/codeblock]
##
## [return] Dictionary with success rates and paradox flag
static func simpsons_paradox_demo() -> Dictionary:
	var group_a = {"treatment": {"success": 20, "total": 100}, "control": {"success": 10, "total": 50}}
	var group_b = {"treatment": {"success": 90, "total": 100}, "control": {"success": 80, "total": 50}}
	
	var combined_treatment = group_a.treatment.success + group_b.treatment.success
	var combined_control = group_a.control.success + group_b.control.success
	var combined_total_t = group_a.treatment.total + group_b.treatment.total
	var combined_total_c = group_a.control.total + group_b.control.total
	
	return {
		"group_a_treatment_rate": float(group_a.treatment.success) / group_a.treatment.total,
		"group_a_control_rate": float(group_a.control.success) / group_a.control.total,
		"group_b_treatment_rate": float(group_b.treatment.success) / group_b.treatment.total,
		"group_b_control_rate": float(group_b.control.success) / group_b.control.total,
		"combined_treatment_rate": float(combined_treatment) / combined_total_t,
		"combined_control_rate": float(combined_control) / combined_total_c,
		"paradox_occurs": (float(group_a.treatment.success) / group_a.treatment.total > float(group_a.control.success) / group_a.control.total) and 
						 (float(group_b.treatment.success) / group_b.treatment.total > float(group_b.control.success) / group_b.control.total) and
						 (float(combined_treatment) / combined_total_t < float(combined_control) / combined_total_c)
	}

## Demonstrates Zeno's Paradox of motion through infinite subdivision.
## Shows how infinite steps can sum to a finite distance.
##
## Zeno argued: To travel a distance, you must first travel half,
## then half the remaining, then half of that... infinite steps!
## But mathematically, the sum converges to the full distance.
##
## [codeblock]
## var distance = stde.zenos_paradox(100, 20)
## print(distance)  # Approaches 100 as iterations increase
## [/codeblock]
##
## [param distance] Total distance to travel
## [param iterations] Number of subdivisions
## [return] Sum of all the half-steps
static func zenos_paradox(distance: float, iterations: int) -> float:
	var total = 0.0
	var current = distance
	for i in range(iterations):
		total += current
		current /= 2.0
	return total

## Demonstrates the Gambler's Fallacy - past events don't affect future odds.
## Always returns the actual probability, regardless of past outcomes.
##
## The gambler's fallacy is believing that after a streak of losses,
## you're "due" for a win. In reality, each independent event has the
## same probability regardless of history.
##
## [codeblock]
## # After 10 losses in a row, what's the chance of winning next?
## var prob = stde.gamblers_fallacy_simulation(10)
## print(prob)  # Still 0.5 (50%)! Past losses don't matter.
## [/codeblock]
##
## [param consecutive_losses] Number of consecutive losses (ignored)
## [param next_bet_win_prob] Actual win probability
## [return] The actual probability (demonstrating the fallacy)
@warning_ignore("unused_parameter")
static func gamblers_fallacy_simulation(consecutive_losses: int, next_bet_win_prob: float = 0.5) -> float:
	return next_bet_win_prob

## Demonstrates Hilbert's Hotel paradox - infinity is weird!
## An infinitely large hotel can accommodate infinite new guests.
##
## Even if Hilbert's Hotel has infinite rooms all occupied, it can fit
## infinite new guests by moving everyone: guest in room N moves to room 2N,
## freeing up all odd-numbered rooms for the new arrivals.
##
## [codeblock]
## var assignments = stde.hilberts_hotel(100, 5)
## print(assignments)  # [101, 102, 103, 104, 105]
## # New guests get rooms starting after current guests
## [/codeblock]
##
## [param current_guests] Number of current guests (room assignments)
## [param new_guests] Number of new guests to accommodate
## [return] Array of room numbers for new guests
static func hilberts_hotel(current_guests: int, new_guests: int) -> Array:
	var room_assignment = []
	for i in range(new_guests):
		room_assignment.append(current_guests + i + 1)
	return room_assignment

## Calculates sphere volume (related to Banach-Tarski paradox).
## The Banach-Tarski paradox shows you can decompose a sphere into pieces
## and reassemble them into TWO identical spheres!
##
## [b]Note:[/b] This just calculates normal volume. The actual paradox
## involves non-measurable sets and the Axiom of Choice.
##
## [codeblock]
## var volume = stde.banach_tarski_volume_sphere(5)
## # In theory, this could become 2x this volume! (But not physically)
## [/codeblock]
##
## [param radius] Radius of the sphere
## [return] Volume using standard formula (4/3)πr³
static func banach_tarski_volume_sphere(radius: float) -> float:
	var original_volume = (4.0 / 3.0) * PI * pow(radius, 3)
	return original_volume

#endregion

#region Quantum & Weird Physics Math

## Calculates probability of Schrödinger's cat being dead after time t.
## Models radioactive decay probability over time.
##
## [codeblock]
## # Half-life of 1 hour (decay_constant = ln(2)/1)
## var prob_dead = stde.schrodingers_cat_probability(1.0, 0.693)
## print("After 1 hour: ", prob_dead * 100, "% dead")  # ~50%
## [/codeblock]
##
## [param time] Time elapsed
## [param decay_constant] Decay constant (ln(2)/half_life)
## [return] Probability of decay (0.0 to 1.0)
static func schrodingers_cat_probability(time: float, decay_constant: float) -> float:
	return 1.0 - exp(-decay_constant * time)

## Calculates minimum momentum uncertainty from Heisenberg's principle.
## ΔxΔp ≥ ℏ/2
##
## Heisenberg's uncertainty principle states you cannot simultaneously
## know both position and momentum with arbitrary precision.
##
## [codeblock]
## var delta_p = stde.heisenberg_uncertainty(1e-10)  # 1 Angstrom position
## print("Momentum uncertainty: ", delta_p, " kg⋅m/s")
## [/codeblock]
##
## [param min_position_uncertainty] Position uncertainty (meters)
## [return] Minimum momentum uncertainty (kg⋅m/s)
static func heisenberg_uncertainty(min_position_uncertainty: float) -> float:
	var h_bar = 1.0545718e-34
	return h_bar / (2.0 * min_position_uncertainty)

## Calculates the Lorentz factor (gamma) for relativistic effects.
## γ = 1/√(1 - v²/c²)
##
## As velocity approaches light speed, time dilation and length
## contraction become significant.
##
## [codeblock]
## var gamma = stde.lorentz_factor(0.9 * 299792458)  # 90% light speed
## print("Time dilation factor: ", gamma)  # ~2.29
## [/codeblock]
##
## [param velocity] Velocity in m/s
## [param speed_of_light] Speed of light (default 299792458 m/s)
## [return] Lorentz factor (γ ≥ 1)
static func lorentz_factor(velocity: float, speed_of_light: float = 299792458.0) -> float:
	var beta = velocity / speed_of_light
	return 1.0 / sqrt(1.0 - beta * beta)

## Calculates time dilation - moving clocks run slower!
##
## [codeblock]
## # Travel at 90% light speed for 1 year (your time)
## var earth_time = stde.time_dilation(1.0, 0.9 * 299792458)
## print("Earth ages ", earth_time, " years")  # ~2.29 years!
## [/codeblock]
##
## [param proper_time] Time experienced by moving observer
## [param velocity] Velocity in m/s
## [param speed_of_light] Speed of light
## [return] Time experienced by stationary observer
static func time_dilation(proper_time: float, velocity: float, speed_of_light: float = 299792458.0) -> float:
	var gamma = lorentz_factor(velocity, speed_of_light)
	return proper_time * gamma

## Calculates quantum tunneling probability.
## Particles can pass through barriers they classically couldn't!
##
## [codeblock]
## var prob = stde.quantum_tunneling_probability(10, 5, 1)
## print("Tunneling probability: ", prob * 100, "%")
## [/codeblock]
##
## [param barrier_height] Energy barrier height
## [param particle_energy] Particle's kinetic energy
## [param barrier_width] Width of the barrier
## [return] Probability of tunneling through (0.0 to 1.0)
static func quantum_tunneling_probability(barrier_height: float, particle_energy: float, barrier_width: float) -> float:
	if particle_energy >= barrier_height:
		return 1.0
	var k = sqrt(2.0 * (barrier_height - particle_energy))
	return exp(-2.0 * k * barrier_width)

## Returns e^(iθ) in rectangular form using Euler's identity.
## e^(iθ) = cos(θ) + i⋅sin(θ)
##
## [codeblock]
## var result = stde.eulers_identity(PI)  # e^(iπ) = -1
## print(result)  # [-1.0, 0.0] (real, imaginary)
## [/codeblock]
##
## [param theta] Angle in radians
## [return] [cos(θ), sin(θ)] representing e^(iθ)
static func eulers_identity(theta: float) -> Array:
	return [cos(theta), sin(theta)]

## Iterates the Mandelbrot set formula to test if a point is in the set.
## Used for generating the famous fractal visualization.
##
## [codeblock]
## var iterations = stde.mandelbrot_iteration(0.0, 0.0)
## if iterations == 100:
##     print("Point is in the Mandelbrot set!")
## [/codeblock]
##
## [param c_real] Real part of complex number c
## [param c_imag] Imaginary part of complex number c
## [param max_iterations] Maximum iterations before assuming convergence
## [return] Number of iterations before divergence (or max_iterations)
static func mandelbrot_iteration(c_real: float, c_imag: float, max_iterations: int = 100) -> int:
	var z_real = 0.0
	var z_imag = 0.0
	var iteration = 0
	
	while iteration < max_iterations and z_real * z_real + z_imag * z_imag < 4.0:
		var new_real = z_real * z_real - z_imag * z_imag + c_real
		var new_imag = 2.0 * z_real * z_imag + c_imag
		z_real = new_real
		z_imag = new_imag
		iteration += 1
	
	return iteration

## The logistic map: demonstrates chaos theory.
## Simple formula that produces complex, chaotic behavior.
##
## [codeblock]
## var x = 0.5
## for i in range(100):
##     x = stde.logistic_map(x, 3.9)  # Chaotic regime
## print(x)  # Unpredictable!
## [/codeblock]
##
## [param x] Current value (0 to 1)
## [param r] Growth rate parameter
## [return] Next value in the sequence
static func logistic_map(x: float, r: float) -> float:
	return r * x * (1.0 - x)

## Generates bifurcation diagram data for the logistic map.
## Shows how chaos emerges as the parameter r increases.
##
## [codeblock]
## var diagram = stde.bifurcation_diagram(2.4, 4.0, 100)
## for r_value in diagram:
##     print("r=", r_value, " values:", diagram[r_value])
## [/codeblock]
##
## [param r_min] Minimum r value
## [param r_max] Maximum r value
## [param steps] Number of r values to sample
## [param iterations] Iterations to reach steady state
## [return] Dictionary mapping r values to arrays of stable points
static func bifurcation_diagram(r_min: float, r_max: float, steps: int, iterations: int = 1000) -> Dictionary:
	var data = {}
	var r_step = (r_max - r_min) / steps
	
	for step in range(steps):
		var r = r_min + step * r_step
		var x = 0.5
		
		for i in range(iterations - 100):
			x = logistic_map(x, r)
		
		var values = []
		for i in range(100):
			x = logistic_map(x, r)
			values.append(x)
		
		data[r] = values
	
	return data

#endregion

#region Simple Encryption & SECURITY

## Encrypts data using XOR cipher with a repeating key.
## Returns hex-encoded string. Use xor_decrypt() to reverse.
##
## [b]Note:[/b] XOR is not secure for real cryptography! Use for
## obfuscation, game save files, or learning purposes only.
##
## [codeblock]
## var encrypted = stde.xor_encrypt("secret message", "mykey")
## print(encrypted)  # Hex string
## var decrypted = stde.xor_decrypt(encrypted, "mykey")
## print(decrypted)  # "secret message"
## [/codeblock]
##
## [param data] String to encrypt
## [param key] Encryption key
## [return] Hex-encoded encrypted string
static func xor_encrypt(data: String, key: String) -> String:
	if data.is_empty() or key.is_empty():
		push_error("xor_encrypt: Data or key cannot be empty")
		return ""
	
	var result = PackedByteArray()
	var key_index = 0
	
	for i in range(data.length()):
		var encrypted_byte = ord(data[i]) ^ ord(key[key_index])
		result.append(encrypted_byte)
		key_index = (key_index + 1) % key.length()

	return result.hex_encode()

## Decrypts XOR-encrypted hex string. Same as xor_encrypt (XOR is symmetric).
##
## [codeblock]
## var encrypted = "48656c6c6f"
## var decrypted = stde.xor_decrypt(encrypted, "key")
## [/codeblock]
##
## [param encrypted_hex] Hex-encoded encrypted string
## [param key] Decryption key (must match encryption key)
## [return] Decrypted string
static func xor_decrypt(encrypted_hex: String, key: String) -> String:
	if encrypted_hex.is_empty() or key.is_empty():
		push_error("xor_decrypt: Encrypted data or key cannot be empty")
		return ""
	
	if encrypted_hex.length() % 2 != 0:
		push_error("xor_decrypt: Invalid hex string length")
		return ""
	
	var encrypted_bytes = PackedByteArray()
	
	for i in range(0, encrypted_hex.length(), 2):
		var byte_str = encrypted_hex.substr(i, 2)
		if not byte_str.is_valid_hex_number():
			push_error("xor_decrypt: Invalid hex character")
			return ""
		encrypted_bytes.append(byte_str.hex_to_int())
	
	var result = ""
	var key_index = 0
	
	for i in range(encrypted_bytes.size()):
		var decrypted_byte = encrypted_bytes[i] ^ ord(key[key_index])
		result += char(decrypted_byte)
		key_index = (key_index + 1) % key.length()
	
	return result

## Creates a seeded substitution cipher mapping.
## Same seed always produces the same cipher.
##
## [codeblock]
## var cipher = stde.create_substitution_cipher(12345)
## print(cipher)  # Dictionary mapping characters
## [/codeblock]
##
## [param key] Seed for random number generator
## [return] Dictionary mapping original characters to substituted ones
static func create_substitution_cipher(key: int) -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.seed = key
	
	var alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	
	var chars = []
	for i in range(alphabet.length()):
		chars.append(alphabet[i])
	
	for i in range(chars.size() - 1, 0, -1):
		var j = rng.randi() % (i + 1)
		var temp = chars[i]
		chars[i] = chars[j]
		chars[j] = temp
	
	var cipher = {}
	for i in range(alphabet.length()):
		var original_char = alphabet[i]
		var substituted_char = chars[i]
		cipher[original_char] = substituted_char
	
	return cipher

## Encrypts text using substitution cipher.
##
## [codeblock]
## var encrypted = stde.substitution_encrypt("Hello World", 12345)
## var decrypted = stde.substitution_decrypt(encrypted, 12345)
## print(decrypted)  # "Hello World"
## [/codeblock]
##
## [param text] Text to encrypt
## [param key] Cipher seed
## [return] Encrypted text
static func substitution_encrypt(text: String, key: int) -> String:
	var cipher = create_substitution_cipher(key)
	var result = ""
	
	for i in range(text.length()):
		var current_char = text[i]
		if cipher.has(current_char):
			result += cipher[current_char]
		else:
			result += current_char  
	
	return result

## Decrypts substitution cipher text.
##
## [param text] Encrypted text
## [param key] Cipher seed (must match encryption key)
## [return] Decrypted text
static func substitution_decrypt(text: String, key: int) -> String:
	var cipher = create_substitution_cipher(key)
	var reverse_cipher = {}
	
	for key_char in cipher:
		reverse_cipher[cipher[key_char]] = key_char
	
	var result = ""
	
	for i in range(text.length()):
		var current_char = text[i]
		if reverse_cipher.has(current_char):
			result += reverse_cipher[current_char]
		else:
			result += current_char  
	
	return result

## Simple hash function for checksums and non-cryptographic hashing.
## Uses the djb2 algorithm.
##
## [b]Note:[/b] Not suitable for security! Use for checksums, hash tables,
## or save file integrity checks.
##
## [codeblock]
## var hash1 = stde.simple_hash("hello")
## var hash2 = stde.simple_hash("hello")
## print(hash1 == hash2)  # true - same input = same hash
## [/codeblock]
##
## [param data] String to hash
## [return] Integer hash value
static func simple_hash(data: String) -> int:
	@warning_ignore("shadowed_global_identifier")
	var hash = 5381
	@warning_ignore("shadowed_global_identifier")
	for char in data:
		hash = ((hash << 5) + hash) + ord(char)
	return hash & 0x7FFFFFFF

## Encodes a string to Base64 format.
##
## [codeblock]
## var encoded = stde.base64_encode("Hello World")
## print(encoded)  # "SGVsbG8gV29ybGQ="
## [/codeblock]
##
## [param data] String to encode
## [return] Base64-encoded string
static func base64_encode(data: String) -> String:
	if data.is_empty():
		push_error("base64_encode: Data cannot be empty")
		return ""
	
	var bytes = data.to_utf8_buffer()
	if bytes.is_empty():
		push_error("base64_encode: Failed to convert string to UTF-8 bytes")
		return ""
	
	return Marshalls.raw_to_base64(bytes)

## Decodes a Base64 string back to normal text.
##
## [codeblock]
## var decoded = stde.base64_decode("SGVsbG8gV29ybGQ=")
## print(decoded)  # "Hello World"
## [/codeblock]
##
## [param data] Base64 string to decode
## [return] Decoded string
static func base64_decode(data: String) -> String:
	if data.is_empty():
		push_error("base64_decode: Data cannot be empty")
		return ""
	
	var clean_data = ""
	for i in range(data.length()):
		var c = data[i]
		if "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".contains(c):
			clean_data += c
	
	if clean_data.is_empty():
		push_error("base64_decode: No valid base64 characters found")
		return ""
	
	while clean_data.length() % 4 != 0:
		clean_data += "="
	
	var bytes = Marshalls.base64_to_raw(clean_data)
	if bytes.is_empty():
		push_error("base64_decode: Failed to decode base64 string")
		return ""
	
	var result = bytes.get_string_from_utf8()
	if result == null:
		push_error("base64_decode: Failed to convert bytes to UTF-8 string")
		return ""
	
	return result

## Encrypts a file using XOR + Base64 encoding.
##
## [codeblock]
## if stde.encrypt_file("res://save_data.json", "secret123"):
##     print("File encrypted successfully!")
## # Creates save_data.json.encrypted
## [/codeblock]
##
## [param path] Path to file to encrypt
## [param key] Encryption key
## [param output_path] Output file path (default: path + ".encrypted")
## [return] True if successful
static func encrypt_file(path: String, key: String, output_path: String = "") -> bool:
	if output_path == "":
		output_path = path + ".encrypted"
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var encrypted = xor_encrypt(content, key)
	var encoded = base64_encode(encrypted)
	
	var out_file = FileAccess.open(output_path, FileAccess.WRITE)
	if not out_file:
		return false
	
	out_file.store_string(encoded)
	out_file.close()
	return true

## Decrypts a file encrypted with encrypt_file().
##
## [codeblock]
## if stde.decrypt_file("res://save_data.json.encrypted", "secret123"):
##     print("File decrypted!")
## [/codeblock]
##
## [param path] Path to encrypted file
## [param key] Decryption key (must match encryption key)
## [param output_path] Output file path (default: removes .encrypted)
## [return] True if successful
static func decrypt_file(path: String, key: String, output_path: String = "") -> bool:
	if output_path == "":
		output_path = path.replace(".encrypted", "")
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return false
	
	var encoded = file.get_as_text()
	file.close()
	
	var encrypted = base64_decode(encoded)
	var decrypted = xor_encrypt(encrypted, key)
	
	var out_file = FileAccess.open(output_path, FileAccess.WRITE)
	if not out_file:
		return false
	
	out_file.store_string(decrypted)
	out_file.close()
	return true

## Derives a consistent key from a password using simple hashing.
##
## [codeblock]
## var key = stde.derive_simple_key("player_password_123")
## # Use this key for encryption
## [/codeblock]
##
## [param password] Password to derive key from
## [param salt] Salt value for key derivation
## [param iterations] Number of hash iterations
## [return] Derived key string
static func derive_simple_key(password: String, salt: String = "stdplus_salt", iterations: int = 1000) -> String:
	var key = password + salt
	for i in range(iterations):
		key = str(simple_hash(key))
	return key.substr(0, 16)

## Obfuscates an integer using XOR.
## Same function encrypts and decrypts (XOR is symmetric).
##
## [codeblock]
## var hidden = stde.obfuscate_int(1000, 12345)
## var revealed = stde.deobfuscate_int(hidden, 12345)
## print(revealed)  # 1000
## [/codeblock]
##
## [param value] Integer to obfuscate
## [param key] Obfuscation key
## [return] Obfuscated integer
static func obfuscate_int(value: int, key: int) -> int:
	return value ^ key

## De-obfuscates an integer (same as obfuscate_int).
##
## [param value] Obfuscated integer
## [param key] Obfuscation key (must match original)
## [return] Original integer
static func deobfuscate_int(value: int, key: int) -> int:
	return value ^ key

## Shuffles an array with a deterministic seed.
## Same seed always produces the same shuffle.
##
## [codeblock]
## var deck = ["A", "2", "3", "4", "5"]
## var shuffled = stde.seeded_shuffle(deck, 42)
## # Players with seed 42 get same shuffle (synchronized)
## [/codeblock]
##
## [param array] Array to shuffle
## [param seed_key] Random seed
## [return] Shuffled copy of the array
static func seeded_shuffle(array: Array, seed_key: int) -> Array:
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_key
	var result = array.duplicate()
	
	for i in range(result.size() - 1, 0, -1):
		var j = rng.randi() % (i + 1)
		var temp = result[i]
		result[i] = result[j]
		result[j] = temp
	
	return result

#endregion

#region Array & Collection Utils

## Shuffles an array randomly (non-deterministic).
## Uses Fisher-Yates shuffle algorithm.
##
## [codeblock]
## var deck = ["A", "K", "Q", "J"]
## var shuffled = stde.shuffle_array(deck)
## print(shuffled)  # Random order each time
## [/codeblock]
##
## [param arr] Array to shuffle
## [return] Shuffled copy of the array
static func shuffle_array(arr: Array) -> Array:
	var result = arr.duplicate()
	for i in range(result.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = result[i]
		result[i] = result[j]
		result[j] = temp
	return result

## Splits an array into chunks of specified size.
##
## [codeblock]
## var items = [1, 2, 3, 4, 5, 6, 7]
## var chunks = stde.array_chunk(items, 3)
## print(chunks)  # [[1,2,3], [4,5,6], [7]]
## [/codeblock]
##
## [param arr] Array to split
## [param size] Size of each chunk
## [return] Array of arrays (chunks)
static func array_chunk(arr: Array, size: int) -> Array:
	var chunks = []
	for i in range(0, arr.size(), size):
		chunks.append(arr.slice(i, min(i + size, arr.size())))
	return chunks

## Returns a random element from an array.
##
## [codeblock]
## var enemies = ["goblin", "orc", "dragon"]
## var random_enemy = stde.pick_random(enemies)
## [/codeblock]
##
## [param arr] Array to pick from
## [return] Random element, or null if array is empty
static func pick_random(arr: Array):
	if arr.is_empty(): return null
	return arr[randi() % arr.size()]

## Returns elements that appear in both arrays.
##
## [codeblock]
## var a = [1, 2, 3, 4]
## var b = [3, 4, 5, 6]
## var common = stde.array_intersect(a, b)
## print(common)  # [3, 4]
## [/codeblock]
##
## [param arr1] First array
## [param arr2] Second array
## [return] Array of common elements
static func array_intersect(arr1: Array, arr2: Array) -> Array:
	var result = []
	for item in arr1:
		if arr2.has(item):
			result.append(item)
	return result

## Returns elements in first array that aren't in second.
##
## [codeblock]
## var all_items = ["sword", "shield", "potion"]
## var inventory = ["sword"]
## var missing = stde.array_difference(all_items, inventory)
## print(missing)  # ["shield", "potion"]
## [/codeblock]
##
## [param arr1] First array
## [param arr2] Second array
## [return] Elements in arr1 not in arr2
static func array_difference(arr1: Array, arr2: Array) -> Array:
	var result = []
	for item in arr1:
		if not arr2.has(item):
			result.append(item)
	return result

## Filters dictionary entries using a callable predicate.
##
## [codeblock]
## var stats = {"hp": 100, "mp": 50, "stamina": 75}
## var high_stats = stde.dict_filter(stats, func(k, v): return v > 60)
## print(high_stats)  # {"hp": 100, "stamina": 75}
## [/codeblock]
##
## [param dict] Dictionary to filter
## [param func_ref] Function that takes (key, value) and returns bool
## [return] Filtered dictionary
static func dict_filter(dict: Dictionary, func_ref: Callable) -> Dictionary:
	var result = {}
	for key in dict:
		if func_ref.call(key, dict[key]):
			result[key] = dict[key]
	return result

## Inverts a dictionary (swaps keys and values).
##
## [codeblock]
## var map = {"a": 1, "b": 2}
## var inverted = stde.dict_invert(map)
## print(inverted)  # {1: "a", 2: "b"}
## [/codeblock]
##
## [param dict] Dictionary to invert
## [return] Inverted dictionary
static func dict_invert(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict:
		result[dict[key]] = key
	return result

#endregion

#region String Operations

## Capitalizes the first letter of each word.
##
## [codeblock]
## var title = stde.capitalize_words("hello world")
## print(title)  # "Hello World"
## [/codeblock]
##
## [param text] Text to capitalize
## [return] Text with each word capitalized
static func capitalize_words(text: String) -> String:
	var words = text.split(" ")
	for i in range(words.size()):
		if words[i].length() > 0:
			words[i] = words[i][0].to_upper() + words[i].substr(1).to_lower()
	return " ".join(words)

## Truncates a string to maximum length with ellipsis.
##
## [codeblock]
## var long_text = "This is a very long description"
## var short = stde.truncate_string(long_text, 20)
## print(short)  # "This is a very lo..."
## [/codeblock]
##
## [param text] Text to truncate
## [param max_length] Maximum length including ellipsis
## [param ellipsis] String to append (default "...")
## [return] Truncated string
static func truncate_string(text: String, max_length: int, ellipsis: String = "...") -> String:
	if text.length() <= max_length:
		return text
	return text.substr(0, max_length - ellipsis.length()) + ellipsis

## Converts text to snake_case.
##
## [codeblock]
## var snake = stde.string_to_snake_case("Hello World")
## print(snake)  # "hello_world"
## [/codeblock]
##
## [param text] Text to convert
## [return] snake_case version
static func string_to_snake_case(text: String) -> String:
	return text.to_lower().replace(" ", "_")

## Converts text to camelCase.
##
## [codeblock]
## var camel = stde.string_to_camel_case("hello world")
## print(camel)  # "helloWorld"
## [/codeblock]
##
## [param text] Text to convert
## [return] camelCase version
static func string_to_camel_case(text: String) -> String:
	var words = text.split(" ")
	var result = words[0].to_lower()
	for i in range(1, words.size()):
		result += words[i].capitalize()
	return result

## Generates a random ID string.
##
## [codeblock]
## var id = stde.generate_id("player_", 8)
## print(id)  # "player_a3k9d2f1"
## [/codeblock]
##
## [param prefix] Optional prefix for the ID
## [param length] Length of random portion
## [return] Random ID string
static func generate_id(prefix: String = "", length: int = 8) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	var result = prefix
	for i in range(length):
		result += chars[randi() % chars.length()]
	return result

## Validates if a string is a properly formatted email address.
##
## [codeblock]
## print(stde.is_valid_email("user@example.com"))  # true
## print(stde.is_valid_email("notanemail"))        # false
## [/codeblock]
##
## [param email] Email string to validate
## [return] True if valid email format
static func is_valid_email(email: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null

#endregion

#region File System Utilities

## Ensures a directory exists, creating it if necessary.
##
## [codeblock]
## if stde.ensure_dir_exists("user://saves/"):
##     print("Save directory ready!")
## [/codeblock]
##
## [param path] Directory path
## [return] True if directory exists or was created successfully
static func ensure_dir_exists(path: String) -> bool:
	var dir = DirAccess.open("res://")
	if dir.dir_exists(path):
		return true
	return dir.make_dir_recursive(path) == OK

## Lists all files in a directory, optionally filtered by extension.
##
## [codeblock]
## var saves = stde.list_files_in_dir("user://saves/", "sav")
## for save_file in saves:
##     print(save_file)
## [/codeblock]
##
## [param path] Directory path
## [param extension] Filter by extension (empty string = all files)
## [return] Array of filenames
static func list_files_in_dir(path: String, extension: String = "") -> Array:
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if extension == "" or file_name.get_extension() == extension:
					files.append(file_name)
			file_name = dir.get_next()
	return files

## Reads and parses a JSON file.
##
## [codeblock]
## var config = stde.read_json("res://config.json")
## if config:
##     print("Max players: ", config.max_players)
## [/codeblock]
##
## [param file_path] Path to JSON file
## [return] Parsed JSON data, or null on failure
static func read_json(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null
	var text = file.get_as_text()
	file.close()
	return JSON.parse_string(text)

## Writes data to a JSON file.
##
## [codeblock]
## var save_data = {"level": 5, "gold": 1000}
## if stde.write_json("user://save.json", save_data):
##     print("Game saved!")
## [/codeblock]
##
## [param file_path] Path to JSON file
## [param data] Data to write (will be JSON.stringify'd)
## [return] True if successful
static func write_json(file_path: String, data: Variant) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	return true

## Returns file size in kilobytes.
##
## [codeblock]
## var size = stde.file_size_kb("res://large_asset.png")
## print("File size: ", size, " KB")
## [/codeblock]
##
## [param path] File path
## [return] File size in KB
static func file_size_kb(path: String) -> float:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return 0.0
	var size = file.get_length()
	file.close()
	return size / 1024.0

#endregion

#region Time and Date

## Formats seconds as a time string (MM:SS or HH:MM:SS).
##
## [codeblock]
## print(stde.format_time(125))       # "02:05"
## print(stde.format_time(3665, true)) # "01:01:05"
## [/codeblock]
##
## [param seconds] Time in seconds
## [param show_hours] If true, always show hours (HH:MM:SS format)
## [return] Formatted time string
static func format_time(seconds: float, show_hours: bool = false) -> String:
	var hours = int(seconds) / 3600
	var minutes = int(seconds) % 3600 / 60
	var secs = int(seconds) % 60
	
	if show_hours or hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, secs]
	else:
		return "%02d:%02d" % [minutes, secs]

## Generates a timestamp string from current system time.
## Format: YYYYMMDD_HHMMSS
##
## [codeblock]
## var filename = "save_" + stde.get_timestamp() + ".dat"
## print(filename)  # "save_20231025_143022.dat"
## [/codeblock]
##
## [return] Timestamp string
static func get_timestamp() -> String:
	var datetime = Time.get_datetime_dict_from_system()
	return "%04d%02d%02d_%02d%02d%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]

## Checks if two Unix timestamps are on the same day.
##
## [codeblock]
## var today = Time.get_unix_time_from_system()
## var yesterday = today - 86400
## print(stde.is_same_day(today, yesterday))  # false
## [/codeblock]
##
## [param unix_time1] First Unix timestamp
## [param unix_time2] Second Unix timestamp
## [return] True if both timestamps are on the same day
static func is_same_day(unix_time1: int, unix_time2: int) -> bool:
	var date1 = Time.get_date_dict_from_unix_time(unix_time1)
	var date2 = Time.get_date_dict_from_unix_time(unix_time2)
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day

## Calculates the number of days between two Unix timestamps.
##
## [codeblock]
## var days = stde.days_between(time1, time2)
## print("Days apart: ", days)
## [/codeblock]
##
## [param unix_time1] First Unix timestamp
## [param unix_time2] Second Unix timestamp
## [return] Number of days between timestamps (absolute value)
static func days_between(unix_time1: int, unix_time2: int) -> int:
	return abs(unix_time1 - unix_time2) / (60 * 60 * 24)

#endregion

#region Color Utilities

## Converts hex color string to Color object.
##
## [codeblock]
## var color = stde.hex_to_color("#FF5733")
## var color2 = stde.hex_to_color("0xFF5733FF")  # With alpha
## [/codeblock]
##
## [param hex] Hex color string (#RRGGBB or #RRGGBBAA)
## [return] Color object
static func hex_to_color(hex: String) -> Color:
	hex = hex.replace("#", "").replace("0x", "")
	if hex.length() == 6:
		hex += "ff"
	
	if hex.length() == 8:
		var r = hex.substr(0, 2).hex_to_int() / 255.0
		var g = hex.substr(2, 2).hex_to_int() / 255.0
		var b = hex.substr(4, 2).hex_to_int() / 255.0
		var a = hex.substr(6, 2).hex_to_int() / 255.0
		return Color(r, g, b, a)
	
	return Color.WHITE

## Converts Color object to hex string.
##
## [codeblock]
## var hex = stde.color_to_hex(Color.RED)
## print(hex)  # "#ff0000"
## [/codeblock]
##
## [param color] Color to convert
## [param include_alpha] If true, includes alpha channel
## [return] Hex color string
static func color_to_hex(color: Color, include_alpha: bool = false) -> String:
	var hex = "#"
	hex += "%02x" % [color.r8]
	hex += "%02x" % [color.g8]
	hex += "%02x" % [color.b8]
	if include_alpha:
		hex += "%02x" % [color.a8]
	return hex

## Linearly interpolates between two colors.
##
## [codeblock]
## var midpoint = stde.lerp_color(Color.RED, Color.BLUE, 0.5)
## # Purple (halfway between red and blue)
## [/codeblock]
##
## [param a] Start color
## [param b] End color
## [param t] Interpolation factor (0.0 to 1.0)
## [return] Interpolated color
static func lerp_color(a: Color, b: Color, t: float) -> Color:
	return Color(
		lerp(a.r, b.r, t),
		lerp(a.g, b.g, t),
		lerp(a.b, b.b, t),
		lerp(a.a, b.a, t)
	)

## Generates a random color with specified saturation and value.
##
## [codeblock]
## var vibrant = stde.random_color(1.0, 1.0)  # Fully saturated
## var pastel = stde.random_color(0.3, 0.9)   # Soft colors
## [/codeblock]
##
## [param saturation] HSV saturation (0.0 to 1.0)
## [param value] HSV value/brightness (0.0 to 1.0)
## [return] Random color
static func random_color(saturation: float = 0.8, value: float = 0.9) -> Color:
	return Color.from_hsv(randf(), saturation, value)

#endregion

#region Game Development

## Checks if a scene file exists before changing.
## Prints a warning with the correct syntax.
##
## [codeblock]
## if stde.change_scene_safe("res://levels/level_2.tscn"):
##     get_tree().change_scene_to_file("res://levels/level_2.tscn")
## [/codeblock]
##
## [param scene_path] Path to scene file
## [return] True if scene exists
static func change_scene_safe(scene_path: String) -> bool:
	if ResourceLoader.exists(scene_path):
		push_warning("STD+: Call get_tree().change_scene_to_file('" + scene_path + "') to actually change scene")
		return true
	else:
		push_error("Scene not found: " + scene_path)
		return false

## Instantiates a scene from a file path.
##
## [codeblock]
## var enemy = stde.instantiate_scene("res://enemies/goblin.tscn")
## if enemy:
##     add_child(enemy)
## [/codeblock]
##
## [param scene_path] Path to scene file
## [return] Instantiated scene node, or null on failure
static func instantiate_scene(scene_path: String) -> Node:
	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		return scene.instantiate()
	push_error("Scene not found: " + scene_path)
	return null

## Finds the first node in a group.
##
## [codeblock]
## var player = stde.find_node_by_group(get_tree(), "player")
## if player:
##     player.take_damage(10)
## [/codeblock]
##
## [param tree] SceneTree to search
## [param group] Group name
## [return] First node in group, or null if none found
static func find_node_by_group(tree: SceneTree, group: String) -> Node:
	var nodes = tree.get_nodes_in_group(group)
	if nodes.size() > 0:
		return nodes[0]
	return null

## Safely queue_free a node with validity check.
##
## [codeblock]
## stde.safe_queue_free(enemy)  # Won't crash if already freed
## [/codeblock]
##
## [param node] Node to free
static func safe_queue_free(node: Node) -> void:
	if node and is_instance_valid(node):
		node.queue_free()

## Checks if an input action was just pressed this frame.
##
## [codeblock]
## if stde.is_input_just_pressed("jump"):
##     player_jump()
## [/codeblock]
##
## [param action] Input action name
## [return] True if just pressed
static func is_input_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(action)

## Gets normalized input vector from four action names.
##
## [codeblock]
## var movement = stde.get_input_vector("left", "right", "up", "down")
## velocity = movement * speed
## [/codeblock]
##
## [param negative_x] Action for left/negative X
## [param positive_x] Action for right/positive X
## [param negative_y] Action for up/negative Y
## [param positive_y] Action for down/positive Y
## [return] Normalized input vector
static func get_input_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String) -> Vector2:
	return Vector2(
		Input.get_axis(negative_x, positive_x),
		Input.get_axis(negative_y, positive_y)
	)

## Creates camera screen shake effect using a tween.
##
## [codeblock]
## var tween = create_tween()
## stde.create_screen_shake(tween, camera, 20.0, 0.5)
## [/codeblock]
##
## [param tween] Tween object to use
## [param camera] Camera2D to shake
## [param intensity] Shake strength in pixels
## [param duration] Shake duration in seconds
static func create_screen_shake(tween: Tween, camera: Camera2D, intensity: float, duration: float) -> void:
	if tween == null:
		push_error("create_screen_shake: Tween cannot be null")
		return
	if camera == null:
		push_error("create_screen_shake: Camera cannot be null")
		return
	if intensity <= 0:
		push_error("create_screen_shake: Intensity must be positive")
		return
	if duration <= 0:
		push_error("create_screen_shake: Duration must be positive")
		return
	
	var original_offset = camera.offset
	var shake_strength = intensity
	
	for i in range(int(duration * 8)):
		var progress = float(i) / (duration * 8)
		var current_intensity = shake_strength * (1.0 - progress)
		
		var random_offset = Vector2(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity)
		)
		var shake_time = duration / (duration * 8)
		
		tween.tween_property(camera, "offset", original_offset + random_offset, shake_time)
	
	tween.tween_property(camera, "offset", original_offset, 0.1)

## Simple one-line screen shake - automatically finds camera and creates tween.
##
## [codeblock]
## stde.create_screen_shake_simple(self, 10.0, 0.5)  # Shake!
## [/codeblock]
##
## [param node] Any node in the scene tree
## [param intensity] Shake strength in pixels
## [param duration] Shake duration in seconds
static func create_screen_shake_simple(node: Node, intensity: float, duration: float) -> void:
	var camera = node.get_viewport().get_camera_2d()
	if camera:
		var tween = node.create_tween()
		tween.set_parallel(true)  # Allow multiple tweens to run in parallel for smoother effect
		create_screen_shake(tween, camera, intensity, duration)

## Advanced screen shake with decay curve and frequency control.
##
## [codeblock]
## stde.create_screen_shake_advanced(
##     camera,
##     15.0,   # Intensity
##     1.0,    # Duration
##     2.0,    # Faster decay (higher = faster falloff)
##     20.0    # Higher frequency = more jittery
## )
## [/codeblock]
##
## [param camera] Camera2D to shake
## [param intensity] Initial shake strength
## [param duration] Total duration
## [param decay_curve] How quickly shake decays (1.0 = linear, >1 = faster)
## [param frequency] Shake frequency (shakes per second)
static func create_screen_shake_advanced(
	camera: Camera2D, 
	intensity: float, 
	duration: float, 
	decay_curve: float = 1.0,
	frequency: float = 15.0
) -> void:
	if camera == null:
		push_error("create_screen_shake_advanced: Camera cannot be null")
		return
	
	var tween = camera.create_tween()
	var original_offset = camera.offset
	var elapsed = 0.0
	
	# Use callbacks for continuous shake
	while elapsed < duration:
		var progress = elapsed / duration
		var current_intensity = intensity * pow(1.0 - progress, decay_curve)
		
		var random_offset = Vector2(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity)
		)
		
		tween.tween_property(camera, "offset", original_offset + random_offset, 1.0 / frequency)
		elapsed += 1.0 / frequency
	
	# Return to original
	tween.tween_property(camera, "offset", original_offset, 0.1)

## Safely connects a signal with validation.
##
## [codeblock]
## if stde.safe_connect(button, "pressed", self, "_on_button_pressed"):
##     print("Connected successfully")
## [/codeblock]
##
## [param source] Object emitting the signal
## [param signal_name] Name of the signal
## [param target] Object with the method
## [param method] Method name to connect to
## [return] True if connection successful
static func safe_connect(source: Object, signal_name: String, target: Object, method: String) -> bool:
	if source and target and source.has_signal(signal_name) and target.has_method(method):
		return source.connect(signal_name, Callable(target, method)) == OK
	return false

## Returns all nodes in a group.
##
## [codeblock]
## var enemies = stde.find_all_nodes_in_group(get_tree(), "enemies")
## for enemy in enemies:
##     enemy.take_damage(10)
## [/codeblock]
##
## [param tree] SceneTree to search
## [param group] Group name
## [return] Array of nodes in the group
static func find_all_nodes_in_group(tree: SceneTree, group: String) -> Array:
	return tree.get_nodes_in_group(group)

## Checks if a node is valid and in the scene tree.
##
## [codeblock]
## if stde.is_node_in_tree(enemy):
##     enemy.position = target_pos
## [/codeblock]
##
## [param node] Node to check
## [return] True if node is valid and in tree
static func is_node_in_tree(node: Node) -> bool:
	return node and node.is_inside_tree()

## Gets the root node of the current scene.
##
## [codeblock]
## var scene_root = stde.get_scene_root(self)
## print("Current scene: ", scene_root.name)
## [/codeblock]
##
## [param node] Any node in the tree
## [return] Root node of the current scene
static func get_scene_root(node: Node) -> Node:
	return node.get_tree().current_scene if node and node.get_tree() else null

#endregion

#region Debug & Development

## Pretty-prints a dictionary with optional title.
##
## [codeblock]
## stde.print_dict(player_stats, "Player Stats")
## # === Player Stats ===
## #   hp: 100
## #   mp: 50
## [/codeblock]
##
## [param dict] Dictionary to print
## [param title] Optional title for the output
static func print_dict(dict: Dictionary, title: String = "") -> void:
	if title != "":
		print("=== ", title, " ===")
	for key in dict:
		print("  ", key, ": ", dict[key])

## Measures execution time of a function.
##
## [codeblock]
## var time = stde.measure_time(func(): expensive_calculation(), 100)
## print("Average time per iteration: ", time / 100, " seconds")
## [/codeblock]
##
## [param func_ref] Callable function to measure
## [param iterations] Number of times to run (default 1)
## [return] Total execution time in seconds
static func measure_time(func_ref: Callable, iterations: int = 1) -> float:
	var start = Time.get_ticks_usec()
	for i in range(iterations):
		func_ref.call()
	var end = Time.get_ticks_usec()
	return (end - start) / 1000000.0

## Validates that a value is not null, printing error if it is.
##
## [codeblock]
## if stde.validate_not_null(player, "Player object"):
##     player.move()
## [/codeblock]
##
## [param variant] Value to check
## [param context] Description for error message
## [return] True if not null, false if null
static func validate_not_null(variant: Variant, context: String = "") -> bool:
	if variant == null:
		push_error("Null value detected: " + context)
		return false
	return true

## Quick check if game is running at good FPS.
##
## [codeblock]
## if not stde.is_performance_good():
##     print("Performance issues detected!")
## [/codeblock]
##
## [return] True if FPS > 55
static func is_performance_good() -> bool:
	return Engine.get_frames_per_second() > 55

## Gets current memory usage in megabytes.
##
## [codeblock]
## var memory = stde.get_memory_usage_mb()
## print("Memory usage: ", memory, " MB")
## [/codeblock]
##
## [return] Static memory usage in MB
static func get_memory_usage_mb() -> float:
	return Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0)

## Gets current frames per second.
##
## [codeblock]
## var fps = stde.get_current_fps()
## fps_label.text = "FPS: " + str(int(fps))
## [/codeblock]
##
## [return] Current FPS
static func get_current_fps() -> float:
	return Engine.get_frames_per_second()

## Prints detailed information about an object.
##
## [codeblock]
## stde.print_object_info(player, "Player Debug")
## # === Player Debug ===
## #   Class: CharacterBody2D
## #   Valid: true
## #   In Tree: true
## #   Name: Player
## [/codeblock]
##
## [param obj] Object to inspect
## [param title] Optional title
static func print_object_info(obj: Object, title: String = "") -> void:
	if title != "":
		print("=== ", title, " ===")
	if obj:
		print("  Class: ", obj.get_class())
		print("  Valid: ", is_instance_valid(obj))
		if obj is Node:
			print("  In Tree: ", obj.is_inside_tree())
			print("  Name: ", obj.name)
	else:
		print("  Object is null")

## Safely sets a property on an object with validation.
##
## [codeblock]
## if stde.safe_set_property(player, "health", 100):
##     print("Health set successfully")
## [/codeblock]
##
## [param obj] Object to modify
## [param property] Property name
## [param value] New value
## [return] True if property was set successfully
static func safe_set_property(obj: Object, property: String, value) -> bool:
	if obj and obj.has_method("set") and obj.get(property) != null:
		obj.set(property, value)
		return true
	return false

#endregion
