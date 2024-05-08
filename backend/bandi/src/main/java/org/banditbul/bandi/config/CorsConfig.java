package org.banditbul.bandi.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter(){
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true); //내 서버가 응답을 할 때 json을 자바스크립트에서 처리할 수 있게 할지를 설정하는 것
        config.addAllowedOrigin("http://192.168.30.152:5173");
        config.addAllowedOrigin("http://192.168.30.107:5173");
        config.addAllowedOrigin("192.168.30.152:5173");
        config.addAllowedOrigin("192.168.30.107:5173");
        config.addAllowedOrigin("http://localhost:5173");
        config.addAllowedOrigin("https://banditbul.co.kr");
        config.addAllowedHeader("*"); // 모든 header에 응답을 허용하겠다.
        config.addAllowedMethod("*"); // 모든 post,get,put,delete,patch 요청을 허용하겠다.
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
