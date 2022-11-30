package com.icorp.MURO

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication(scanBasePackages = ["com.icorp"])
class MuroApplication

fun main(args: Array<String>) {
	runApplication<MuroApplication>(*args)
}
