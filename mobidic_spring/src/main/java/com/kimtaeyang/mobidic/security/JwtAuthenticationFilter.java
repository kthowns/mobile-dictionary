package com.kimtaeyang.mobidic.security;

import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.NO_MEMBER;


@Component
@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtUtil jwtUtil;
    private final MemberRepository memberRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7); // "Bearer " 제거
        if (jwtUtil.validateToken(token)) {
            String userId = jwtUtil.getUserIdFromToken(token);
            UserDetails userDetails = memberRepository.findById(UUID.fromString(userId))
                    .orElseThrow(() -> new ApiException(NO_MEMBER, NO_MEMBER.getMessage() + userId));

            //SecurityContext에 인증 정보 저장
            UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

            SecurityContextHolder.getContext().setAuthentication(authToken);
            log.info("OK : " + userDetails.getUsername());
            log.info("Authenticated User: " + userDetails.getUsername());
            log.info("User Authorities: " + userDetails.getAuthorities());
        }

        filterChain.doFilter(request, response);
    }
}
