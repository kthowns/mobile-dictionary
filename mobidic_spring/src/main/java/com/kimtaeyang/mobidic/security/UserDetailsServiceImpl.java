package com.kimtaeyang.mobidic.security;

import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.NO_MEMBER;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl  implements UserDetailsService {
    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return memberRepository.findByEmail(email)
                .orElseThrow(() -> new ApiException(NO_MEMBER, NO_MEMBER.getMessage() + email));
    }
}
