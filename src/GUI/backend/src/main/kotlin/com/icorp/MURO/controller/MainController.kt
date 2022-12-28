package com.icorp.MURO.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController


@RestController
// @RequestMapping("/api")
class MainController {

    // @CrossOrigin(origins = arrayOf("http://localhost:8080"))
    @GetMapping("/home")
    fun helloKotlin(@RequestParam input:String): String {
        // Runtime.getRuntime().exec("powershell.exe -File C:\\Users\\bgates\\Desktop\\MURO_TFG\\MURO\\src\\helloworld.ps1 -WebInput $input");
        Runtime.getRuntime().exec("powershell.exe -File C:\\Users\\bgates\\Desktop\\MURO_TFG\\MURO\\src\\fwEditor.ps1 -WebInput $input");
        System.out.println(input);
        return "0";
    }
}