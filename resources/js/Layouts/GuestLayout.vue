<script setup>
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import { Link } from '@inertiajs/vue3';
import Footer from '@/Components/Footer.vue';
</script>

<template>
    <nav class="navbar navbar-expand-lg position-absolute fixed-top top-0 z-index-4 w-100 shadow-none my-3  navbar-transparent mt-4  " color-on-scroll="100" id="sectionsNav">
        <div class="container">
            <div class="navbar-translate">
                <a class="navbar-brand" href="javascript:void(0)">
                    RamsAI Gordon
                </a>
            </div>
            <div class="py-lg-0 d-flex justify-content-end" id="navigation">
                <ul class="navbar-nav ">
                    <li class="nav-item mx-2">
                        <Link class="nav-link" href="/">Sākums</Link>
                    </li>
                    <li class="nav-item mx-2">
                        <Link class="nav-link" href="/login">Ienākt</Link>
                    </li>
                    <li class="nav-item mx-2">
                        <Link class="nav-link" href="/register">Reģistrēties</Link>
                    </li>
                    <li class="nav-item mx-2">
                        <Link class="nav-link" :href="route('password.request')">Atjaunot paroli</Link>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="page-header header-filter" style="background-image: url('/assets/img/bg7.png'); background-size: cover; background-position: top center;">
        <div class="container">
            <slot/>
        </div>
        <Footer />
    </div>
</template>

<script>
    export default {
        data() {
            return {
                year: new Date().getFullYear()
            }
        },
        mounted(){
            document.body.classList.add('login-page', 'sidebar-collapse')
        },
        beforeUnmount(){
            document.body.classList.remove('login-page', 'sidebar-collapse')
        },
    }
</script>
