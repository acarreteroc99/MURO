package com.icorp.MURO.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController


@RestController
// @RequestMapping("/api")
class TestController {

    @CrossOrigin(origins = arrayOf("http://localhost:8080"))
    @GetMapping("/home")
    fun helloKotlin(): String {
        System.out.println("===  HELLOW WORLD  ===");
        return "0";
    }
}