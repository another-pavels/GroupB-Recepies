<template>
    <Head title="Sākums" />

    <AuthenticatedLayout
        :pageTitle="pageTitle"
        :greeting="greetingText"
        headerBackground="https://ca-times.brightspotcdn.com/dims4/default/8076e3a/2147483647/strip/true/crop/2048x1365+0+0/resize/1200x800!/quality/80/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F96%2F87%2Fd8ac5e4c68e213fbcc77c53f4bfb%2Fla-1549576254-v61sh258hb-snap-image"
        headerFilter="header-filter-extended-digituvi"
    >
        <div v-if="recipe.recipe_status == 2" class="row mt-0">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h3 class="card-title">Pagatavošanas instrukcija</h3>
                        <ol class="instructions">
                            <li v-for="(instruction, index) in recipe.instructions" :key="index">
                                {{ instruction }}
                            </li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card mt-5">
                    <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                        <a class="d-block blur-shadow-image">
                            <img :src="imageUrl" alt="img-blur-shadow" class="img-fluid shadow border-radius-lg" style="width: 100%;" loading="lazy">
                        </a>
                        <div class="colored-shadow" :style="imageStyle">
                        </div>
                    </div>
                    <div class="card-body">
                        <h5 class="font-weight-normal">Sastāvdaļas</h5>
                        <ul class="p-0">
                            <li v-for="(ingredient, index) in ingredients" :key="index" class="d-flex justify-content-between">
                                <span class="ingredient-name">{{ ingredient.name }}</span>
                                <span>{{ ingredient.pivot.quantity }}</span>
                            </li>
                        </ul>
                        <h5 class="font-weight-normal">Nutrišnal vērtība</h5>
                        <ul class="p-0">
                            <li v-for="(item, index) in recipe.nutrition" :key="index" class="d-flex justify-content-between">
                                {{ item }}
                            </li>
                        </ul>
                        <h5 class="font-weight-normal">{{creator.name}} prasīja</h5>
                        <p>{{ recipe.user_prompt }}</p>

                    </div>
                </div>
            </div>
        </div>
        <div v-if="recipe.recipe_status == 3" class="row mt-0 justify-content-center">
            <div class="col-md-6">
                <div class="card mt-0">
                    <div class="card-body">
                        <h3 class="card-title">Ko darīt?</h3>
                    </div>
                    <div class="card-footer justify-content-between">
                        <!-- create retry and delete buttons -->
                        <button class="btn btn-outline-danger" @click="deleteRecipe">Dzēst</button>
                        <button class="btn btn-outline-primary" @click="retryRecipe">Mēģināt vēlreiz</button>
                    </div>
                </div>

            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
import DatatableCard from '@/Components/DatatableCard.vue';
import axios from 'axios';

    export default {
        components: {
            AuthenticatedLayout,
            Head,
        },
        props: {
            recipe: {
                type: Object,
                required: true
            },
            ingredients: {
                type: Array,
                required: true
            },
            creator: {
                type: Object,
                required: true
            },
        },
        data: () => ({
            // set interval to refresh page every 5 seconds
            interval: null,
        }),
        computed: {
            pageTitle() {
                return this.recipe.recipe_status == 2 ? this.recipe.name : 'Nepabeigta recepte #' + this.recipe.id;
            },
            greetingText() {
                if(this.recipe.recipe_status == 0) return "Recepte vēl nav pabeigta";
                if(this.recipe.recipe_status == 1) return "Recepte tiek izstrādāta";
                if(this.recipe.recipe_status == 3) return "KĻŪDA: neizdevās izdomāt recepti";
                return this.recipe.image_prompt;
            },
            imageUrl() {
                if(this.recipe.image_status == 2) {
                    return route('recipes.image', this.recipe);
                }
                return '/assets/img/dish_placeholder.jpg';
            },
            imageStyle() {
                return {
                    backgroundImage: `url(${this.imageUrl})`,
                    // size cover
                    backgroundSize: 'cover',
                };
            },
        },
        methods: {
            deleteRecipe() {
                if(confirm('Vai tiešām vēlaties dzēst šo recepti?')) {
                    this.$inertia.delete('/recipes/' + this.recipe.id);
                }
            },
            retryRecipe() {
                if (this.interval) {
                    clearInterval(this.interval);
                }
                if(confirm('Vai tiešām vēlaties mēģināt vēlreiz?')) {
                    axios.get('/recipes/' + this.recipe.id + '/retry');
                    this.initPolling();
                }
            },
            initPolling() {
                // set interval to refresh page every 5 seconds
                this.interval = setInterval(() => {
                    this.$inertia.reload({ only: ['recipe', 'ingredients'] });
                    if (this.recipe.image_status == 2 || this.recipe.recipe_status == 3) {
                        this.stopPolling();
                    }
                }, 5000);
            },
            stopPolling() {
                clearInterval(this.interval);
            }
        },
        mounted() {
            if(this.recipe.recipe_status == 1 || this.recipe.recipe_status == 0) {
                this.initPolling();
            }

        }
    }
</script>

<style>
    .ingredient-name {
        text-transform: capitalize;
    }
    li.d-flex.justify-content-between {
        margin-bottom: 0.5rem;
        border-bottom: #e3e3e3 1px dotted;
    }
    .instructions {
        counter-reset: step;
        list-style-type: none;
        padding-left: 0;
        font-size: large;
    }
    .instructions li {
        display: block;
        margin-bottom: 1rem;
    }

    .instructions li:before {
        content: counter(step);
        counter-increment: step;
        display: inline-block;
        width: 2em;
        height: 2em;
        line-height: 2em;
        text-align: center;
        border: 3px solid #ccc;
        border-radius: 2em;
        margin-right: 1em;
        background-color: white;
    }
</style>
