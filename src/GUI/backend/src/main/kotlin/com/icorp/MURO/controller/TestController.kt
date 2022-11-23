package com.icorp.MURO.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class TestController {

    @GetMapping("/home")
    fun helloKotlin(): String {
        return "hello world"
    }
}