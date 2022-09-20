
# remap a value from one range to another
static func remap(value: float, istart: float, istop: float, ostart: float, ostop: float):
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

# chooses a random element in a dictionary, weighed by its key : float
# sum of all keys should not be superior to 1
static func weighted_random_choice(dict : Dictionary):
    # key: weights
    # values: whatever it is that we're choosing
    var rand_val = randf()
    var total = 0
    for k in dict.keys():
        total += dict[k]
        if rand_val <= total:
            return k
    push_error('unreachable')
