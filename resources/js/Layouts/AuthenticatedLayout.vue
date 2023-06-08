<script setup>
import { ref } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';
import Navigation from '@/Components/Navigation.vue';
import { computed } from 'vue';
import Footer from '@/Components/Footer.vue';

const showingNavigationDropdown = ref(false);
</script>

<template>
    <nav class="navbar navbar-color-on-scroll fixed-top  navbar-expand-lg" :class="{'navbar-transparent': pageOffset < 101 }" id="sectionsNav">
        <div class="container">
            <div class="navbar-translate">
                <Link class="navbar-brand" :href="route('home')">
                    <div class="logo-big">
                        <img src="/assets/img/logo1.png" class="img-fluid">
                        {{appName}}
                    </div>
                    <div class="logo-small">
                        <img src="/assets/img/logo1.png" class="img-fluid">
                        {{appName}}
                    </div>
                </Link>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="navbar-toggler-icon"></span>
                    <span class="navbar-toggler-icon"></span>
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
            <div class="collapse navbar-collapse">
                <Navigation/>
            </div>
        </div>
    </nav>
    <div class="page-header header-filter header-small" :class="headerFilter" data-parallax="true" :style="backgroundImage">
        <div class="container">
            <div class="row">
                <div class="col-md-8 ml-auto mr-auto text-center">
                    <h1 class="title">{{pageTitle}}</h1>
                    <h4>{{greeting}}</h4>
                </div>
            </div>
        </div>
    </div>

    <div class="container raised-content">
        <slot/>
    </div>

    <Footer />
</template>

<script>
    export default {
        props: {
            "greeting": String,
            "pageTitle": String,
            "headerBackground": {
                type: String,
                default: "/assets/img/bg9.jpg"
            },
            "headerFilter": {
                type: String,
                default: "header-filter-default"
            }
        },
        data() {
            return {
                pageOffset: 0,
            }
        },
        computed: {
            appName() {
                return this.$page.props.app.name;
            },
            year() {
                return new Date().getFullYear();
            },
            backgroundImage() {
                return `background-image: url('${this.headerBackground}');`;
            },
        },
        mounted() {
            window.addEventListener('scroll', this.handleScroll);
        },
        beforeUnmount() {
            window.removeEventListener('scroll', this.handleScroll);
        },
        methods: {
            handleScroll() {
                this.pageOffset = window.pageYOffset;
            }
        }
    }
</script>
