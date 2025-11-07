package com.boot.config;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir:uploads}")  // 설정 없으면 'uploads' 기본값
    private String uploadDir;

    private String resolvedDir() {
        Path p = Paths.get(uploadDir).toAbsolutePath().normalize();
        File dir = p.toFile();
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return p.toString().replace("\\", "/");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String base = resolvedDir();
        if (!base.endsWith("/")) base += "/";
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:" + base+"/");
    }
}
