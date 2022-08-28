package com.sha.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.retry.annotation.EnableRetry;

/**
 * @author sa
 * @date 27.08.2022
 * @time 18:45
 */
@EnableRetry
@SpringBootApplication
public class WorkerApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(WorkerApplication.class, args);
    }
}
