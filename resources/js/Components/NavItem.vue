<script setup>
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <li v-if="!subItems" class="dropdown nav-item">
        <Link
            :href="route(routeName)"
            class="nav-link"
        >
        <i class="material-icons">{{icon}}</i> {{title}}
        </Link>
    </li>
    <li v-else class="dropdown nav-item">
        <a href="#" class="dropdown-toggle nav-link" data-bs-toggle="dropdown">
            <i class="material-icons">{{icon}}</i> {{title}}
        </a>
        <div class="dropdown-menu dropdown-with-icons">
            <Link v-for="(subItem, index) in subItems" :key="index" :href="route(subItem.routeName)" class="dropdown-item">
                <i class="material-icons">{{subItem.icon}}</i> {{subItem.title}}
            </Link>
        </div>
    </li>
</template>

<script>
    export default {
        props : {
            title: {
                type: String,
                required: true,
            },
            icon: {
                type: String,
                required: true,
            },
            routeName: {
                type: String,
                required: false,
            },
            subItems: {
                type: Array,
                required: false,
            },
        }
    }
</script>
