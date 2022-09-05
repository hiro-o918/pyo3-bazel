package golib

import "github.com/rs/zerolog/log"


func Echo(message string) {
	log.Info().Msg(message)
}
