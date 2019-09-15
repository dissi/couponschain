import Vue from 'vue';
import Router from 'vue-router';
import Profile from '@/views/Profile';
import List from '@/views/List';
import Register from '@/views/Register';
import RegisterCampagne from '@/views/RegisterCampagne';
import ListCampagne from '@/views/ListCampagne';
import ListCampagneTraite from '@/views/ListCampagneTraite';
import ListCampagneNonTraite from '@/views/ListCampagneNonTraite';
import GenererCoupon from '@/views/GenererCoupon';
import AcquerirCoupon from '@/views/AcquerirCoupon';
import TransfererCoupon from '@/views/TransfererCoupon';
import ListCoupon from '@/views/ListCoupon';
import ListCouponRedeem from '@/views/ListCouponRedeem';
import RedeemCoupon from '@/views/RedeemCoupon';
import ListCouponConsommateur from '@/views/ListCouponConsommateur';
import MesCouponConsommateur from '@/views/MesCouponConsommateur';
import ListProduits from '@/views/ListProduits';

Vue.use(Router);

export default new Router({
    routes: [
        {
            path: '/',
            name: 'List',
            component: List
        },
        {
            path: '/profile',
            name: 'Profile',
            component: Profile
        },
        {
            path: '/register',
            name: 'Register',
            component: Register
        },
        {
            path: '/registercampagne',
            name: 'RegisterCampagne',
            component: RegisterCampagne
        },
        {
            path: '/listcampagne',
            name: 'ListCampagne',
            component: ListCampagne
        },
        {
            path: '/listcampagnetraite',
            name: 'ListCampagneTraite',
            component: ListCampagneTraite
        },
        {
            path: '/listcampagnenontraite',
            name: 'ListCampagneNonTraite',
            component: ListCampagneNonTraite
        },
         {
            path: '/generercoupon/:idCamp',
            name: 'GenererCoupon',
            component: GenererCoupon,
            props:true
        },
         {
            path: '/acquerircoupon/:idCoup',
            name: 'AcquerirCoupon',
            component: AcquerirCoupon,
            props:true
        },
         {
            path: '/transferercoupon/:idCoup',
            name: 'TransfererCoupon',
            component: TransfererCoupon,
            props:true
        },
         {
            path: '/recuperercoupon/:idCoup',
            name: 'RedeemCoupon',
            component: RedeemCoupon,
            props:true
        },
        {
            path: '/listcoupon',
            name: 'ListCoupon',
            component: ListCoupon
        },
        {
            path: '/listcouponredeem',
            name: 'ListCouponRedeem',
            component: ListCouponRedeem
        },
        {
            path: '/listcouponconsommateur',
            name: 'ListCouponConsommateur',
            component: ListCouponConsommateur
        },
        {
            path: '/mescouponconsommateur',
            name: 'MesCouponConsommateur',
            component: MesCouponConsommateur
        },
        {
            path: '/listproduits',
            name: 'ListProduits',
            component: ListProduits
        },
    ],
    linkActiveClass: 'active'
});
