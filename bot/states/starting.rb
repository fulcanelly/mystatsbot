class BaseMoscalState < BaseState
    def me_when_smth_applied
        if gender == :male 
            "свого москаля"
        else 
            "свою москальку"
        end
    end

end




#TODO: add remove kb on next say() call option


class RespawnState < BaseState 
    
    def run 
        #TODO : implement death count 
        suggest_it("Ваш москаль помер ⚰️\n\n Що робити ?")
            .option("Воскресити москаля") do 
                switch_state MainMenuState.new 
            end
            .option("Створити нового") do 
                switch_state SuicideState.new
            end
            .exec()
    end

end


#TODO: implement stats showing state

#TODO: add stats builder
class StatsShowingState < BaseState
    
    def run 
        say(
            "Карма вашого москаля #{3}\n" + 
            "Вік вашого москаля: #{2}\n" +
            "Ваш москаль помер  #{1}\n" 
        )

        switch_state MainMenuState.new 
    end

end




class SuicideState < BaseState


    def run 
        suggest_it("Як ви хочете вбити свого москаля ?")
            .option("Повіситись 🧶") do 
                say "Ви залізли на стула, оділи петлю та стрибнули, хеппі енд"    
            end
            .option("Застрелитись 🔫") do 
                say "Ви взяли рушницю та пустили кулю в голову 💥"
            end
            .option("Втопитись 💦") do 
                say "Ви стрибнули з моста та покормили рибок 🐋"
            end
            .option('Відміна') do 
                switch_state MainMenuState.new
            end
            .exec()

        
        switch_state RespawnState.new
    end

end 


class WalkingInTownState < BaseState 
    def run 

        run_sometimes do 
            say("Будьте обрежні зараз йде мобілізація 🪖")
        end
        
        suggest_it("Ви вийшли в місто 🌆") 
            .option("Назад додму 🏘") do 
                switch_state MainMenuState.new 
            end
            .option("Hz") do 
                switch_state MainMenuState.new 
            end
            .exec 

    end

end


class MainMenuState < BaseState 
    def run 
        suggest_it("Ваш москаль лежить дома 🏘")
            .option("Показати мого москаля") do 
                switch_state StatsShowingState.new() 
            end
            .option("Покормити москаля 🍴") do 
                say "Ви покормили москаля 🍽 \n\nНащо їжу на таке переводити..."
            end
            .option("Вийти на вулицю 🌆") do 
                switch_state WalkingInTownState.new
            end
            .option("Померти ☠️") do 
                switch_state SuicideState.new 
            end
            .exec
        
        switch_state self

    end

end


class CharacterGenerationState < BaseState 

    def _gen_age() 
        rand 18..40
    end

    def _gen_occupation()
        [
            :student,
            :military,
            :worker,
            :unemployed
        ].sample
    end

    def _gen_location() 
        [
            :city,
            :willage,
            :west 
        ].sample
    end


    def run() 

        say "Придумайте iм'я вашому москалю"
        name = expect_text 
        
        sex = _suggest("Оберіть стать москаля", ["Чоловіча", "Жіноча"])
 
        say "Генеруємо вік москаля..."
        age = _gen_age()

        say "Генеруємо род діяльності та інше..."
        occupation = _gen_occupation()
        location = _gen_location()


        say(
            "Готово!\n\n" + 
            "Вашого москаля звати #{name}\n" +
            "Йому #{age} років, (sex:#{sex}) \n\n" +
            "Проживає в #{location}"
        )

        switch_state MainMenuState.new 

    end
     
end

class StartingState < BaseState 

    def run
        
        #just to skip /start command 
        expect_text

        say "Ласкаво просимо до нашого бота 🇺🇦"
        say "Цей бот розроблено з метою зібрати кошти на ЗСУ і дати можливість людям відчути себе більш залученими в боротьбу з москалями"
        _suggest("Адже як відомо - русофобії багато не буває", ['Почати гру'])
    

        say(
            "Ще один факт - у москалів немає свободи волі, " + 
            "тому у грі ви маєте власного москаля який повністью вам підкоряється"
        )


        switch_state CharacterGenerationState.new
    end

end