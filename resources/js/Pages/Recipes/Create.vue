<template>
    <Head title="Sākums" />

    <AuthenticatedLayout
        :pageTitle="greetingText"
        greeting="Ko liksi uz kārā zoba?"
    >
    <div class="card mt-0">
            <div class="card-body">
                <h3 class="card-title">Recepšu ģenerātors</h3>
                <div class="form-group">
                    <label>Angļu valodā ieraksti sastāvdaļas, ko vēlies izmantot, atdalot tās ar komatu</label>
                    <input type="text" class="form-control" v-model="ingredients" placeholder="Piemēram: Peas, pineaple, black pepper, mayonnaise" autofocus>
                </div>
                <div class="form-group">
                    <label>Izvēlies virtuvi</label>
                    <select class="form-control" v-model="cuisine">
                        <option value="any">Jebkura</option>
                        <option value="American">Amerikāņu</option>
                        <option value="British">Britu</option>
                        <option value="Chinese">Ķīniešu</option>
                        <option value="French">Franču</option>
                        <option value="Greek">Grieķu</option>
                        <option value="Indian">Indiešu</option>
                        <option value="Italian">Itāļu</option>
                        <option value="Japanese">Japāņu</option>
                        <option value="Mediterranean">Vidusjūras</option>
                        <option value="Mexican">Meksikāņu</option>
                        <option value="Moroccan">Marokāņu</option>
                        <option value="Spanish">Spāņu</option>
                        <option value="Thai">Taizemiešu</option>
                        <option value="Vietnamese">Vjetnamiešu</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Izvēlies produktus, kurus nevari lietot (arī angliski)</label>
                    <input type="text" class="form-control" v-model="dietaryRestrictions" placeholder="Piemēram: Dairy, lactose, nuts, raspberry" autofocus>
                </div>
            </div>
            <div class="card-footer justify-content-end">
                <button class="btn btn-primary" @click="$inertia.visit(route('recipes.store', {ingredients: ingredients, cuisine: cuisine, dietaryRestrictions: dietaryRestrictions}), {method: 'post'})">Ģenerēt</button>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';

    export default {
        components: {
            AuthenticatedLayout,
            Head
        },
        data: () => ({
            ingredients: '',
            cuisine: 'any',
            dietaryRestrictions: '',
        }),
        computed: {
            greetingText() {
                let hour = new Date().getHours();
                let greeting;
                if (hour >= 3 && hour <= 11) {
                    greeting =  "Labrīt";
                } else if (hour >= 12 && hour <= 18) {
                    greeting =  "Labdien";
                } else if (hour >= 19 || hour <= 2) {
                    greeting =  "Labvakar";
                }

                return greeting + ', ' + this.$page.props.auth.user.name;
            }
        }
    }
</script>
