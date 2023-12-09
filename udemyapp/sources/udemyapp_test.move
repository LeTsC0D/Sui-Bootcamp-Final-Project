#[test_only]
module udemyapp::udemyapp_test {
    use std::vector;
    use std::debug::print as print;
    use sui::coin;
    use std::string:: {Self, String};
    use sui::sui::SUI;
    use sui::balance;
    use sui::test_scenario as ts;

    use udemyapp::udemyapp as bj;


    #[test]
    fun test_udemy_hub() {
        let user = @0xCAFE;
        let house = @0xFAAA;
        let test = ts::begin(user);

        let scenario = &mut test;

        ts::next_tx(scenario, user);
        {
            let coin = coin::mint_for_testing<SUI>(200000001, ts::ctx(scenario));

            // let randomness = get_randomness_for_test();
            let randomness = vector[];
            vector::push_back(&mut randomness, 50);
            vector::push_back(&mut randomness, 60);
            vector::push_back(&mut randomness, 40);
            vector::push_back(&mut randomness, 30);
            vector::push_back(&mut randomness, 30);
            vector::push_back(&mut randomness, 30);

            let udemyhub = ts::take_shared<bj::UdemyHub>(scenario);
            let coursehub = ts::take_shared<bj::CourseHub>(scenario);
            bj::create_courseCategory(randomness,randomness,randomness,randomness,randomness,&mut udemyhub,&mut coursehub, coin, ts::ctx(scenario));
            ts::return_shared(coursehub);
            ts::return_shared(udemyhub);
        };
        ts::end(test);
    }
}
