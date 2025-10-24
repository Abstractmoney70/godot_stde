class_name stde
extends Node

#region Math & Financial Utilities

@warning_ignore("shadowed_global_identifier")
static func clamp_min(value, min):
	return max(value, min)

@warning_ignore("shadowed_global_identifier")
static func clamp_max(value, max):
	return min(value, max)

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

static func sqr(val):
	if val == null:
		push_error("sqr: Value cannot be null")
		return 0
	return val * val

static func cube(val):
	if val == null:
		push_error("cube: Value cannot be null")
		return 0
	return val * val * val

static func round_inc(val, increment):
	if increment == 0:
		return val
	elif increment < 0:
		push_error("round_inc: Increment cannot be negative")
		return val
	return round(val / increment) * increment

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

static func map(value, from_min, from_max, to_min, to_max):
	if from_max == from_min:
		return (to_min + to_max) / 2.0
	return to_min + ((value - from_min) / (from_max - from_min)) * (to_max - to_min)

static func simple_intrst(princ, rate, time):
	if princ == null or rate == null or time == null:
		push_error("simple_intrst: Arguments are missing!")
		return 0
	
	if princ <= 0 or rate <= 0 or time <= 0:
		push_warning("Interest calculation with non-positive values may not make sense")
	
	var si = (princ * rate * time) / 100
	return si

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

static func cubrt(val: float) -> float:
	if val == null:
		push_error("cubrt: Value cannot be null")
		return 0.0
	if val < 0:
		return -pow(-val, 1.0/3.0)
	return pow(val, 1.0/3.0)

static func per_to_dec(val: float):
	if val == null:
		push_error("per_to_dec: Value cannot be null")
		return 0.0
	val = clampf(val, 0, 100)
	if val == 0:
		return 0
	var a = val / 100
	return a

static func dec_to_per(val: float):
	if val == null:
		push_error("dec_to_per: Value cannot be null")
		return 0.0
	var a = clamp((val * 100), 0, 100)
	if val == 0:
		return 0
	return a

static func wrap_angle(angle):
	if angle == null:
		push_error("wrap_angle: Angle cannot be null")
		return 0.0
	return fmod(angle + PI, 2 * PI) - PI

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
static func complex_multiply(a_real: float, a_imag: float, b_real: float, b_imag: float) -> Array:
	if a_real == null or a_imag == null or b_real == null or b_imag == null:
		push_error("complex_multiply: Arguments cannot be null")
		return [0.0, 0.0]
	var real = a_real * b_real - a_imag * b_imag
	var imag = a_real * b_imag + a_imag * b_real
	return [real, imag]

static func complex_power(real: float, imag: float, power: float) -> Array:
	if real == null or imag == null or power == null:
		push_error("complex_power: Arguments cannot be null")
		return [0.0, 0.0]
	var r = sqrt(real * real + imag * imag)
	var theta = atan2(imag, real)
	var new_r = pow(r, power)
	var new_theta = theta * power
	return [new_r * cos(new_theta), new_r * sin(new_theta)]

static func complex_magnitude(real: float, imag: float) -> float:
	if real == null or imag == null:
		push_error("complex_magnitude: Arguments cannot be null")
		return 0.0
	return sqrt(real * real + imag * imag)

static func complex_conjugate(real: float, imag: float) -> Array:
	if real == null or imag == null:
		push_error("complex_conjugate: Arguments cannot be null")
		return [0.0, 0.0]
	return [real, -imag]
#endregion

#region New Vector Math
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

static func vec2_rotate(v: Vector2, angle: float) -> Vector2:
	if v == null or angle == null:
		push_error("vec2_rotate: Arguments cannot be null")
		return Vector2.ZERO
	var cos_a = cos(angle)
	var sin_a = sin(angle)
	return Vector2(v.x * cos_a - v.y * sin_a, v.x * sin_a + v.y * cos_a)
#endregion

#region Numerical Methods
static func derivative(func_ref: Callable, x: float, h: float = 0.0001) -> float:
	if func_ref == null or x == null or h == null:
		push_error("derivative: Arguments cannot be null")
		return 0.0
	if h <= 0:
		push_error("derivative: Step size h must be positive")
		return 0.0
	return (func_ref.call(x + h) - func_ref.call(x - h)) / (2.0 * h)

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
static func triangle_area_heron(a: float, b: float, c: float) -> float:
	var s = (a + b + c) / 2.0
	return sqrt(s * (s - a) * (s - b) * (s - c))

static func triangle_area_points(a: Vector2, b: Vector2, c: Vector2) -> float:
	return abs((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2.0)

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

static func net_present_value(cash_flows: Array, discount_rate: float) -> float:
	var npv = 0.0
	for i in range(cash_flows.size()):
		npv += cash_flows[i] / pow(1 + discount_rate, i)
	return npv

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

static func black_scholes_call_price(S: float, K: float, T: float, r: float, sigma: float) -> float:
	var d1 = (log(S / K) + (r + 0.5 * sigma * sigma) * T) / (sigma * sqrt(T))
	var d2 = d1 - sigma * sqrt(T)
	return S * norm_cdf(d1) - K * exp(-r * T) * norm_cdf(d2)

static func norm_cdf(x: float) -> float:
	return 0.5 * (1 + erf(x / sqrt(2)))

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

static func rule_of_72(rate: float) -> float:
	return 72.0 / rate

static func continuous_compound(principal: float, rate: float, time: float) -> float:
	return principal * exp(rate * time / 100.0)

#endregion

#region Paradoxes & Counterintuitive Maths

static func birthday_paradox(people: int, days_in_year: int = 365) -> float:
	var prob_no_match = 1.0
	for i in range(people):
		prob_no_match *= float(days_in_year - i) / float(days_in_year)
	return 1.0 - prob_no_match

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

static func benfords_law(digit: int) -> float:
	if digit < 1 or digit > 9:
		return 0.0
	return log(1.0 + 1.0 / digit) / log(10.0)

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

static func zenos_paradox(distance: float, iterations: int) -> float:
	var total = 0.0
	var current = distance
	for i in range(iterations):
		total += current
		current /= 2.0
	return total

@warning_ignore("unused_parameter")
static func gamblers_fallacy_simulation(consecutive_losses: int, next_bet_win_prob: float = 0.5) -> float:
	return next_bet_win_prob

static func hilberts_hotel(current_guests: int, new_guests: int) -> Array:
	var room_assignment = []
	for i in range(new_guests):
		room_assignment.append(current_guests + i + 1)
	return room_assignment

static func banach_tarski_volume_sphere(radius: float) -> float:
	var original_volume = (4.0 / 3.0) * PI * pow(radius, 3)
	return original_volume

#endregion

#region Quantum & Weird Physics Math

static func schrodingers_cat_probability(time: float, decay_constant: float) -> float:
	return 1.0 - exp(-decay_constant * time)

static func heisenberg_uncertainty(min_position_uncertainty: float) -> float:
	var h_bar = 1.0545718e-34
	return h_bar / (2.0 * min_position_uncertainty)

static func lorentz_factor(velocity: float, speed_of_light: float = 299792458.0) -> float:
	var beta = velocity / speed_of_light
	return 1.0 / sqrt(1.0 - beta * beta)

static func time_dilation(proper_time: float, velocity: float, speed_of_light: float = 299792458.0) -> float:
	var gamma = lorentz_factor(velocity, speed_of_light)
	return proper_time * gamma

static func quantum_tunneling_probability(barrier_height: float, particle_energy: float, barrier_width: float) -> float:
	if particle_energy >= barrier_height:
		return 1.0
	var k = sqrt(2.0 * (barrier_height - particle_energy))
	return exp(-2.0 * k * barrier_width)

static func eulers_identity(theta: float) -> Array:
	return [cos(theta), sin(theta)]

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

static func logistic_map(x: float, r: float) -> float:
	return r * x * (1.0 - x)

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

static func simple_hash(data: String) -> int:
	@warning_ignore("shadowed_global_identifier")
	var hash = 5381
	@warning_ignore("shadowed_global_identifier")
	for char in data:
		hash = ((hash << 5) + hash) + ord(char)
	return hash & 0x7FFFFFFF

static func base64_encode(data: String) -> String:
	if data.is_empty():
		push_error("base64_encode: Data cannot be empty")
		return ""
	
	var bytes = data.to_utf8_buffer()
	if bytes.is_empty():
		push_error("base64_encode: Failed to convert string to UTF-8 bytes")
		return ""
	
	return Marshalls.raw_to_base64(bytes)

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

static func derive_simple_key(password: String, salt: String = "stdplus_salt", iterations: int = 1000) -> String:
	var key = password + salt
	for i in range(iterations):
		key = str(simple_hash(key))
	return key.substr(0, 16)

static func obfuscate_int(value: int, key: int) -> int:
	return value ^ key

static func deobfuscate_int(value: int, key: int) -> int:
	return value ^ key

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

static func shuffle_array(arr: Array) -> Array:
	var result = arr.duplicate()
	for i in range(result.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = result[i]
		result[i] = result[j]
		result[j] = temp
	return result

static func array_chunk(arr: Array, size: int) -> Array:
	var chunks = []
	for i in range(0, arr.size(), size):
		chunks.append(arr.slice(i, min(i + size, arr.size())))
	return chunks

static func pick_random(arr: Array):
	if arr.is_empty(): return null
	return arr[randi() % arr.size()]

static func array_intersect(arr1: Array, arr2: Array) -> Array:
	var result = []
	for item in arr1:
		if arr2.has(item):
			result.append(item)
	return result

static func array_difference(arr1: Array, arr2: Array) -> Array:
	var result = []
	for item in arr1:
		if not arr2.has(item):
			result.append(item)
	return result

static func dict_filter(dict: Dictionary, func_ref: Callable) -> Dictionary:
	var result = {}
	for key in dict:
		if func_ref.call(key, dict[key]):
			result[key] = dict[key]
	return result

static func dict_invert(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict:
		result[dict[key]] = key
	return result

#endregion

#region String Operations

static func capitalize_words(text: String) -> String:
	var words = text.split(" ")
	for i in range(words.size()):
		if words[i].length() > 0:
			words[i] = words[i][0].to_upper() + words[i].substr(1).to_lower()
	return " ".join(words)

static func truncate_string(text: String, max_length: int, ellipsis: String = "...") -> String:
	if text.length() <= max_length:
		return text
	return text.substr(0, max_length - ellipsis.length()) + ellipsis

static func string_to_snake_case(text: String) -> String:
	return text.to_lower().replace(" ", "_")

static func string_to_camel_case(text: String) -> String:
	var words = text.split(" ")
	var result = words[0].to_lower()
	for i in range(1, words.size()):
		result += words[i].capitalize()
	return result

static func generate_id(prefix: String = "", length: int = 8) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	var result = prefix
	for i in range(length):
		result += chars[randi() % chars.length()]
	return result

static func is_valid_email(email: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null

#endregion

#region File System Utilities

static func ensure_dir_exists(path: String) -> bool:
	var dir = DirAccess.open("res://")
	if dir.dir_exists(path):
		return true
	return dir.make_dir_recursive(path) == OK

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

static func read_json(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null
	var text = file.get_as_text()
	file.close()
	return JSON.parse_string(text)

static func write_json(file_path: String, data: Variant) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	return true

static func file_size_kb(path: String) -> float:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return 0.0
	var size = file.get_length()
	file.close()
	return size / 1024.0

#endregion

#region Time and Date

static func format_time(seconds: float, show_hours: bool = false) -> String:
	var hours = int(seconds) / 3600
	var minutes = int(seconds) % 3600 / 60
	var secs = int(seconds) % 60
	
	if show_hours or hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, secs]
	else:
		return "%02d:%02d" % [minutes, secs]

static func get_timestamp() -> String:
	var datetime = Time.get_datetime_dict_from_system()
	return "%04d%02d%02d_%02d%02d%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]

static func is_same_day(unix_time1: int, unix_time2: int) -> bool:
	var date1 = Time.get_date_dict_from_unix_time(unix_time1)
	var date2 = Time.get_date_dict_from_unix_time(unix_time2)
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day

static func days_between(unix_time1: int, unix_time2: int) -> int:
	return abs(unix_time1 - unix_time2) / (60 * 60 * 24)

#endregion

#region Color Utilities

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

static func color_to_hex(color: Color, include_alpha: bool = false) -> String:
	var hex = "#"
	hex += "%02x" % [color.r8]
	hex += "%02x" % [color.g8]
	hex += "%02x" % [color.b8]
	if include_alpha:
		hex += "%02x" % [color.a8]
	return hex

static func lerp_color(a: Color, b: Color, t: float) -> Color:
	return Color(
		lerp(a.r, b.r, t),
		lerp(a.g, b.g, t),
		lerp(a.b, b.b, t),
		lerp(a.a, b.a, t)
	)

static func random_color(saturation: float = 0.8, value: float = 0.9) -> Color:
	return Color.from_hsv(randf(), saturation, value)

#endregion

#region Game Development

static func change_scene_safe(scene_path: String) -> bool:
	if ResourceLoader.exists(scene_path):
		push_warning("STD+: Call get_tree().change_scene_to_file('" + scene_path + "') to actually change scene")
		return true
	else:
		push_error("Scene not found: " + scene_path)
		return false

static func instantiate_scene(scene_path: String) -> Node:
	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		return scene.instantiate()
	push_error("Scene not found: " + scene_path)
	return null

static func find_node_by_group(tree: SceneTree, group: String) -> Node:
	var nodes = tree.get_nodes_in_group(group)
	if nodes.size() > 0:
		return nodes[0]
	return null

static func safe_queue_free(node: Node) -> void:
	if node and is_instance_valid(node):
		node.queue_free()

static func is_input_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(action)

static func get_input_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String) -> Vector2:
	return Vector2(
		Input.get_axis(negative_x, positive_x),
		Input.get_axis(negative_y, positive_y)
	)

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

static func create_screen_shake_simple(node: Node, intensity: float, duration: float) -> void:
	var camera = node.get_viewport().get_camera_2d()
	if camera:
		var tween = node.create_tween()
		tween.set_parallel(true)  # Allow multiple tweens to run in parallel for smoother effect
		create_screen_shake(tween, camera, intensity, duration)

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

static func safe_connect(source: Object, signal_name: String, target: Object, method: String) -> bool:
	if source and target and source.has_signal(signal_name) and target.has_method(method):
		return source.connect(signal_name, Callable(target, method)) == OK
	return false

static func find_all_nodes_in_group(tree: SceneTree, group: String) -> Array:
	return tree.get_nodes_in_group(group)

static func is_node_in_tree(node: Node) -> bool:
	return node and node.is_inside_tree()

static func get_scene_root(node: Node) -> Node:
	return node.get_tree().current_scene if node and node.get_tree() else null

#endregion

#region Debug & Development

static func print_dict(dict: Dictionary, title: String = "") -> void:
	if title != "":
		print("=== ", title, " ===")
	for key in dict:
		print("  ", key, ": ", dict[key])

static func measure_time(func_ref: Callable, iterations: int = 1) -> float:
	var start = Time.get_ticks_usec()
	for i in range(iterations):
		func_ref.call()
	var end = Time.get_ticks_usec()
	return (end - start) / 1000000.0

static func validate_not_null(variant: Variant, context: String = "") -> bool:
	if variant == null:
		push_error("Null value detected: " + context)
		return false
	return true

static func is_performance_good() -> bool:
	return Engine.get_frames_per_second() > 55

static func get_memory_usage_mb() -> float:
	return Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0)

static func get_current_fps() -> float:
	return Engine.get_frames_per_second()

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

static func safe_set_property(obj: Object, property: String, value) -> bool:
	if obj and obj.has_method("set") and obj.get(property) != null:
		obj.set(property, value)
		return true
	return false

#endregion
