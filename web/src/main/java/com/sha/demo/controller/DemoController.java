package com.sha.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author sa
 * @date 28.08.2022
 * @time 12:07
 */
@RestController
public class DemoController
{
    @GetMapping("test")
    public ResponseEntity<String> test()
    {
        return ResponseEntity.ok("web");
    }
}
