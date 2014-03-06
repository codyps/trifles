/* start
 * SDA: 1 => 0
 * SCL: 1-----
 */

/* stop
 * SDA: 0 => 1
 * SCL: 1-----
 */

/* SDA is valid on rising and falling edges,
 * changes when SCL=0, valid when SCL=1
 *
 */

/*
 * State machine, assuming [DATA] bits, [START] and [STOP]
 * signals are the only things fed in (detecting these is
 * seperate)
 *
 * 13bits of state (started:1, byte:8, bit_index:4)
 * Arguably, 'byte' is not part of the state, so 5 bits.
 *
 * If we mix the started and bit_index, we can cut it down to
 * 4 bits total (assuming one has no need to track bits when
 * stopped)
 *
 *        *UNKNOWN----\
 *        /     |      \
 * [START]    [STOP]   [DATA]
 *    |         |
 *    |       !STARTED
 *    |      /   ^
 *    |  [START] |
 *    |   /      |
 * {1}|  /
 * STARTED -> [STOP]
 *   |  \  \
 *   |   \  ^
 *   |    \ |
 * [DATA] [START]
 *   |
 *   {2}
 *
 *
 * {1} : byte = 0; started = 1; bit_index = 0;
 * {2} : if (bit_index < 8)
 *		byte <<= 1; byte |= sda; bit_index++;
 *	 else
 *		bit_index = 0;
 *		NOTE_ACK(sda);
 *
 *
 *
 * PREV CURR DELTA
 * 0    0    0
 * 0    1    1
 * 1    0    -1
 * 1	1    0
 *
 * SDA_D	SCL_D	COND
 * 0		0	none
 * 0		1	data
 * 0		-1	data (ignored)
 * 1		0	if (scl) STOP
 * 1		1	INVALID
 * 1		-1	INVALID
 * -1		0	if (scl) START
 * -1		1	INVALID
 * -1		-1	INVALID
 *
 */

#include <stdbool.h>
#include <stdint.h>

enum I2C_STATE {
	I2C_STATE_STOPPED,
	I2C_STATE_0,
	I2C_STATE_1,
	I2C_STATE_2,
	I2C_STATE_3,
	I2C_STATE_4,
	I2C_STATE_5,
	I2C_STATE_6,
	I2C_STATE_7,
	I2C_STATE_8,
};

struct i2c_state {
	uint8_t byte;
	uint8_t prev_sda:1,
		prev_scl:1,
		state:4,
		reserved1:2;
};

typedef int_least8_t im11;
#define bool_to_im11(b) ((im11)(b) << 1 - 1)


#define DEFINE_I2C_TRACKER(_n) DEFINE_I2C_TRACKER_(_n##_, \
		_n##_start, _n##_stop, _n##_data, _n##_invalid)

/*
 * _start(struct i2c_state *s)
 * _stop(struct i2c_state *s)
 * _data(struct i2c_state *s, bool sda_or_nack)
 * _invalid(struct i2c_state *s, im11 delta_sda, im11 delta_scl)
 */
#define DEFINE_I2C_TRACKER_(_n, _start, _stop, _data, _invalid)	\
static void _n##i2c_state_start(struct i2c_state *s)		\
{								\
	_start(s);						\
	s->state = I2C_STATE_0;					\
}								\
static void _n##i2c_state_stop(struct i2c_state *s)		\
{								\
	_stop(s);						\
	s->state = I2C_STATE_STOPPED;				\
}								\
static void _n##i2c_state_data(struct i2c_state *s, bool sda)	\
{								\
	if (s->state - 1 < 8) {					\
		s->byte <<= 1;					\
		s->byte |= sda;					\
		s->state ++;					\
	} else {						\
		_data(s, sda);					\
		s->state = I2C_STATE_0;				\
	}							\
}								\
static void _n##i2c_state_invalid(struct i2c_state *s,		\
		im11 d_sda, im11 d_scl)				\
{								\
	_invalid(s, d_sda, d_scl);				\
	_n##i2c_state_stop(s);					\
}								\
static void _n##i2c_inputs(struct i2c_state *s,			\
		bool sda, bool scl)				\
{								\
	im11 d_sda = (im11)sda - s->prev_sda,			\
	     d_scl = (im11)scl - s->prev_scl;			\
	if (d_sda == 0) {					\
		if (d_scl == 1) {				\
			_n##i2c_state_data(s, sda);		\
		} else {					\
			/* d_scl == 0 || d_scl == -1 */		\
			/* none       ,  ignored */		\
		}						\
	} else if (d_sda == 1) {				\
		if (d_scl == 0) {				\
			_n##i2c_state_stop(s);			\
		} else {					\
			_n##i2c_state_invalid(s, d_sda, d_scl); \
		}						\
	} else /* if (d_sda == -1) */ {				\
		if (d_scl == 0) {				\
			_n##i2c_state_start(s);			\
		} else {					\
			_n##i2c_state_invalid(s, d_sda, d_scl);	\
		}						\
	}							\
	s->prev_sda = sda;					\
	s->prev_scl = scl;					\
}
