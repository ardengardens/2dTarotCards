-- interpretations.lua
-- Card meanings used by the Offline mode. Edit this file whenever you like:
-- the game re-reads it for every offline reading, so just save it and click
-- "New Reading". No restart needed.
--
-- HOW TO ADD A CARD
-- Copy one of the entries below, paste it inside `cards`, and change the name.
-- The name must match the card exactly, for example:
--   "The Fool", "Death", "Ace of Cups", "Three of Swords", "Queen of Pentacles"
-- (Suits: Wands, Cups, Swords, Pentacles. Ranks: Ace, Two ... Ten, Page,
--  Knight, Queen, King.)
--
-- Each card can have these lists of text. Every one is optional:
--   past    = shown when the card lands in the Past / Context position
--   present = shown in the Present / Focus position
--   future  = shown in the Possible Direction position
--   any     = used for any position that has no list of its own
--
-- Put several strings in a list and one is picked at random each time,
-- so adding more lines gives you more variety.
--
-- Cards with no entry still work: the game uses that card's keywords and
-- tells you at the end of the reading which cards still need text.
--
-- TIPS
-- * Every string needs quotes around it and a comma after it.
-- * To use a double quote inside a string, write \" (or use single quotes).
-- * Plain keyboard characters are safest, since the built-in font does not
--   cover every symbol.

return {

  -- Short lead-in sentence for each position, picked at random and placed
  -- before the card's own text. Add as many as you like.
  intros = {
    past = {
      "This position looks at the background and earlier influences behind your question.",
      "Here the cards describe what has been shaping the situation.",
    },
    present = {
      "This position shows the dynamic that deserves your attention right now.",
      "Here the cards describe where the energy is gathering at the moment.",
    },
    future = {
      "This position points to a possibility that may emerge if things continue as they are.",
      "Here the cards describe a direction you could be moving toward.",
    },
  },

  -- Closing thoughts, one is picked at random.
  closings = {
    "Take what resonates and leave the rest. The cards are a mirror for your own reflection, not a forecast.",
    "Read the three cards together as one story, and notice which part of it feels most true to you.",
    "Nothing here is fixed. Use the spread as a prompt for your own thinking, then decide what you want to do.",
  },

  cards = {

    ["The Fool"] = {
      past = {
        "You may have recently stepped into something new without knowing how it would turn out. That leap of trust is still part of the story.",
        "An earlier moment of openness or spontaneity set this situation in motion, even if it felt reckless at the time.",
      },
      present = {
        "You are standing at a threshold. Curiosity matters more than certainty right now, and a small first step counts.",
        "There is room to begin again here. Try holding your plans loosely and see what opens up.",
      },
      future = {
        "A fresh start is possible, one that asks for trust and a willingness to be a beginner.",
        "If you keep your openness, an unexpected path may appear. Look before you leap, but do leap.",
      },
    },

    ["The Tower"] = {
      past = {
        "Something that once felt solid was shaken or revealed to be unstable. The aftershocks may still be shaping how you see this.",
      },
      present = {
        "A sudden change or hard truth is pressing in. It may be uncomfortable, but it is clearing away something that could not hold.",
      },
      future = {
        "A shake-up may be coming. If a foundation feels shaky, it may be better to reinforce it, or let it go, before it forces the issue.",
      },
    },

    ["The Star"] = {
      -- "any" works in every position, which is handy when one text fits all.
      any = {
        "A quiet sense of hope and renewal runs through this card. After difficulty, there is healing, inspiration, and the feeling that things can be gentle again.",
      },
    },

    ["Death"] = {
      past = {
        "An ending, not necessarily a loss, made way for what you are dealing with now. Something had to be released.",
      },
      present = {
        "You are in a season of transition. Something is finishing so that something else can begin, and resisting it may cost more than allowing it.",
      },
      future = {
        "A chapter may be closing, and with it comes room for transformation. What you let go of now makes space for what is next.",
      },
    },

    ["Ace of Cups"] = {
      past = {
        "An opening of the heart, a new feeling, connection, or creative spark, planted the seed for what you are asking about.",
      },
      present = {
        "Emotional openness is available to you now. Pay attention to what moves you, and let kindness, to yourself and others, lead.",
      },
      future = {
        "A new emotional beginning is within reach, such as a relationship, a creative outlet, or a renewed sense of meaning.",
      },
    },

    ["Three of Swords"] = {
      past = {
        "A painful truth or heartbreak left a mark. Naming the hurt honestly is part of how it eventually heals.",
      },
      present = {
        "There is sorrow or disappointment to acknowledge. Letting yourself feel it clearly may be easier than carrying it unspoken.",
      },
      future = {
        "A hard conversation or difficult realization may be ahead. It may sting, but it can also bring clarity and relief.",
      },
    },

    ---------------------------------------------------------------
    -- MAJOR ARCANA (the rest)
    ---------------------------------------------------------------

    ["The Magician"] = {
      past = { "You discovered that you had more resources and skill than you realized, and an earlier act of will got this situation moving." },
      present = { "You have the tools you need within reach. Focus your attention on one clear intention and take the first deliberate step." },
      future = { "Focused action can turn an idea into something real. If you gather your resources and commit, the way forward is open." },
    },

    ["The High Priestess"] = {
      past = { "Something you sensed but never said aloud has been shaping events. A quiet inner knowing was already at work." },
      present = { "Not everything is visible yet. Slow down, listen inward, and trust what you notice beneath the surface before you act." },
      future = { "A deeper understanding may surface if you make room for stillness. Answers are more likely to arrive through listening than through pushing." },
    },

    ["The Empress"] = {
      past = { "A period of care, creativity, or abundance nourished the foundation of this situation. What was tended then is still growing." },
      present = { "This is a time to nurture, whether a project, a relationship, or yourself. Patience and generosity will do more than force." },
      future = { "Growth and fruitfulness are possible if you keep tending what matters. Creative energy may be about to bear something tangible." },
    },

    ["The Emperor"] = {
      past = { "Structure, authority, or firm boundaries shaped how things unfolded. Rules you set, or lived under, still echo here." },
      present = { "Clear structure and steady leadership are called for. Decide where your boundaries are and hold them calmly." },
      future = { "Building a dependable framework could give you stability and direction. Disciplined planning now may pay off well." },
    },

    ["The Hierophant"] = {
      past = { "Tradition, teachers, or shared values formed the ground you stand on. Lessons learned from others still guide your choices." },
      present = { "Consider what established wisdom or community can teach you here. Learning from those who have gone before may serve you better than going it alone." },
      future = { "You may be drawn toward a mentor, an institution, or a set of shared values. Deciding which traditions you truly want to keep could be the next step." },
    },

    ["The Lovers"] = {
      past = { "A meaningful connection, or an important choice about values, set this course. What you chose then still reflects who you are." },
      present = { "You face a choice that is really about alignment. Ask what honors your values and what you can commit to honestly." },
      future = { "A deepening bond or a clarifying decision may be ahead. Choosing in line with your values can make the way forward feel whole." },
    },

    ["The Chariot"] = {
      past = { "Determination and self-discipline carried you through a struggle. The momentum you built then still shapes where you are." },
      present = { "Pulling competing forces in one direction takes focus and will. Pick your course and steer with confidence." },
      future = { "Steady drive could carry you to a hard-won victory. Keep your direction clear and hold the reins firmly." },
    },

    ["Strength"] = {
      past = { "Quiet courage and patience helped you through something difficult. Gentleness, not force, is what got you here." },
      present = { "Meet the situation with calm confidence and compassion, including toward yourself. Soft strength can steady what harshness would inflame." },
      future = { "Patience and inner courage will serve you well in what comes. You may find that gentleness accomplishes what pressure cannot." },
    },

    ["The Hermit"] = {
      past = { "A time of solitude or withdrawal gave you perspective. What you learned alone still guides you." },
      present = { "Stepping back to reflect may be the wisest move right now. Look for answers within before consulting the crowd." },
      future = { "A period of reflection may lead to real insight. Following your own inner light, even if it means some quiet for a while, could clarify the way." },
    },

    ["Wheel of Fortune"] = {
      past = { "A turning point shifted your circumstances, perhaps beyond your control. The cycle that began then is still in motion." },
      present = { "Things are in motion and change is in the air. Notice what is rising and what is falling, and adapt rather than resist." },
      future = { "A cycle may be turning in a new direction. Staying flexible will help you meet whatever the turn brings." },
    },

    ["Justice"] = {
      past = { "Choices and their consequences, fairness or the lack of it, helped form this situation. Past decisions are still being weighed." },
      present = { "Honesty and accountability matter now. See the situation clearly, weigh the facts fairly, and act in line with the truth." },
      future = { "A clear and balanced outcome may follow from choices made with integrity. Cause and effect are likely to become visible." },
    },

    ["The Hanged Man"] = {
      past = { "A pause, a surrender, or a forced waiting period changed how you see things. That shift in perspective still colors this situation." },
      present = { "Stuck is not the same as failing. Pausing and looking at the situation from another angle may reveal what pushing has not." },
      future = { "Letting go of control could open a new viewpoint. A willing pause now may lead to a breakthrough later." },
    },

    ["Temperance"] = {
      past = { "A period of balance, patience, or blending opposites set a calmer tone. The moderation you found then still steadies you." },
      present = { "Seek the middle path. Blending different needs, and avoiding extremes, will help you find a sustainable rhythm." },
      future = { "Harmony and healing may come through patience and moderation. Slowly integrating what seems opposed could bring lasting balance." },
    },

    ["The Devil"] = {
      past = { "An attachment, temptation, or limiting pattern took hold earlier on. Its grip may still be influencing your choices." },
      present = { "Notice what you feel bound to, and whether the chain is really locked. Naming a limiting pattern is the first step toward loosening it." },
      future = { "If an unhealthy attachment continues, it may keep narrowing your options. Choosing freedom, even in small ways, can begin to loosen it." },
    },

    ["The Moon"] = {
      past = { "Uncertainty, dreams, or half-seen truths clouded your view. Some of what happened then has never been fully clear." },
      present = { "Things are not as clear as they seem, and fears can distort shadows. Move gently, trust your intuition, and wait for clearer light before big decisions." },
      future = { "Confusion may lift as you pay attention to your dreams and instincts. Keep going carefully, and the path will become clearer." },
    },

    ["The Sun"] = {
      past = { "A time of joy, warmth, or clarity lit this situation. That vitality is still a source of strength." },
      present = { "There is energy, honesty, and openness here. Let yourself enjoy what is going well and share your light." },
      future = { "Brighter days and greater clarity may be on the way. Optimism and vitality are likely to feel natural." },
    },

    ["Judgement"] = {
      past = { "A reckoning or awakening changed how you see yourself. Answering that call set you on a new course." },
      present = { "You are being asked to reflect honestly and respond to a call. Forgiveness, including of yourself, can free you to move on." },
      future = { "An awakening or a decisive turning point may be near. Heeding your inner call could mark the start of a new chapter." },
    },

    ["The World"] = {
      past = { "A significant chapter reached completion. What you accomplished then is part of the foundation you stand on." },
      present = { "You are near completion and integration. Recognize how far you have come, and let yourself feel what you have accomplished." },
      future = { "A cycle may come to a satisfying close, with a sense of wholeness. Completion often opens the door to the next beginning." },
    },

    ---------------------------------------------------------------
    -- WANDS (energy, ambition, creativity, action)
    ---------------------------------------------------------------

    ["Ace of Wands"] = {
      past = { "A spark of inspiration or ambition set things in motion. That original impulse is still burning." },
      present = { "A fresh surge of energy and possibility is available. Act on the idea that excites you." },
      future = { "A new project, passion, or opportunity may ignite. If the spark feels real, give it room to grow." },
    },

    ["Two of Wands"] = {
      past = { "You stood at a point of planning and weighing options, and the choice you made then still shapes your path." },
      present = { "You are deciding between staying safe and venturing out. Look at the bigger picture and plan your next move." },
      future = { "A wider horizon may open if you commit to a plan. Bold but considered steps could expand your world." },
    },

    ["Three of Wands"] = {
      past = { "Earlier efforts began to take shape and you looked toward wider horizons. That early progress laid the groundwork." },
      present = { "Your plans are in motion and you are waiting for results. Keep your eyes on the horizon and stay patient." },
      future = { "Growth and expansion may be ahead as your efforts come back to you. Collaboration could widen your reach." },
    },

    ["Four of Wands"] = {
      past = { "A time of celebration or stability marked a milestone. That sense of home and community remains a base." },
      present = { "There is reason to celebrate progress and enjoy a stable foundation. Share the moment with the people who support you." },
      future = { "Harmony, community, and a joyful milestone may be ahead. Taking time to appreciate your achievements could be part of it." },
    },

    ["Five of Wands"] = {
      past = { "Competition or friction created conflict that shaped this situation. The struggle left its mark." },
      present = { "Many voices and clashing ambitions are in play. Not every disagreement is a fight, so look for what the friction can teach." },
      future = { "Conflict or rivalry may continue unless you find common ground. Healthy competition can sharpen things if it is handled well." },
    },

    ["Six of Wands"] = {
      past = { "A victory or moment of recognition boosted your confidence. That success still colors how you move." },
      present = { "Progress is being recognized. Stay grounded in the work that earned it, and carry your confidence with humility." },
      future = { "Acknowledgment and success may be near. Staying true to your efforts will keep the win meaningful." },
    },

    ["Seven of Wands"] = {
      past = { "You defended your position against challenges, and that resilience is part of your story." },
      present = { "You are holding your ground under pressure. Stand firm in what you believe, and remember that you have the higher position." },
      future = { "You may need to defend something that matters to you. Perseverance and clear conviction can see you through." },
    },

    ["Eight of Wands"] = {
      past = { "Things moved quickly, with messages and momentum arriving all at once. That rush set the pace." },
      present = { "Events are speeding up. Stay alert, act decisively, and keep your focus so the momentum works for you." },
      future = { "Swift developments and news may arrive. Be ready to move when the moment comes." },
    },

    ["Nine of Wands"] = {
      past = { "You have been through challenges and carry the weariness of them. Your resilience got you this far." },
      present = { "You are tired but nearly there. One last effort of perseverance, and a little rest, can carry you the rest of the way." },
      future = { "A final test may come before you reach the finish line. Your endurance has prepared you for it." },
    },

    ["Ten of Wands"] = {
      past = { "You carried a heavy load of responsibility for a long time. That burden shaped how you work." },
      present = { "You may be shouldering too much. Consider what you can set down or share, and what truly needs to be carried." },
      future = { "The weight of responsibility may peak before it eases. Delegating or simplifying could lighten the way." },
    },

    ["Page of Wands"] = {
      past = { "A spark of curiosity or an eager message sent you exploring something new. That enthusiasm was a beginning." },
      present = { "Curiosity and a willingness to learn are your assets now. Explore the idea, even if you are not sure where it leads." },
      future = { "A new idea, message, or creative invitation may arrive. Meeting it with an open, playful attitude will help." },
    },

    ["Knight of Wands"] = {
      past = { "A burst of passion and fast action drove you forward, and the momentum of that charge still echoes." },
      present = { "Energy and drive are high, but watch for impulsiveness. Move with purpose, not just speed." },
      future = { "Bold, energetic action may carry you toward your goal. Pace yourself so enthusiasm does not outrun planning." },
    },

    ["Queen of Wands"] = {
      past = { "Confidence, warmth, and creative passion shaped how you handled things. That magnetism opened doors." },
      present = { "Lead with warmth and self-assurance. Trust your own creative power and let people see your spark." },
      future = { "Growing confidence and charisma may bring you what you want. Staying true to yourself will inspire others." },
    },

    ["King of Wands"] = {
      past = { "Visionary leadership or bold decisions set the direction of this situation. That authority still has influence." },
      present = { "You are being called to lead with vision and integrity. Think big, but follow through with disciplined action." },
      future = { "Mature leadership and a clear vision may carry things forward. Guide with purpose and inspire those around you." },
    },

    ---------------------------------------------------------------
    -- CUPS (emotions, connection, relationships, imagination)
    -- Ace of Cups is near the top of this file.
    ---------------------------------------------------------------

    ["Two of Cups"] = {
      past = { "A bond of mutual respect or partnership formed earlier. That connection still colors your expectations." },
      present = { "Two sides are meeting in balance and honesty. Give and receive in equal measure." },
      future = { "A meaningful partnership or reconciliation may be possible. Mutual care and openness will be its foundation." },
    },

    ["Three of Cups"] = {
      past = { "Friendship and celebration brought joy and support. Those connections remain a resource." },
      present = { "Community and shared joy are available now. Lean on friends and enjoy being together." },
      future = { "A gathering, friendship, or shared success may lift your spirits. Celebrating with others can restore your energy." },
    },

    ["Four of Cups"] = {
      past = { "A stretch of apathy or withdrawal made it hard to see what was offered. That contemplation shaped your view." },
      present = { "You may be bored or disengaged and overlooking what is in front of you. Check whether something is being offered that you have not noticed." },
      future = { "A new opportunity could appear if you are open to seeing it. Re-engaging with curiosity may shift your mood." },
    },

    ["Five of Cups"] = {
      past = { "Loss or disappointment left you focused on what was spilled. That grief shaped your outlook." },
      present = { "It is natural to feel sorrow over what is gone. Remember that something is still standing behind you." },
      future = { "Moving beyond regret may become possible. Turning toward what remains can start the healing." },
    },

    ["Six of Cups"] = {
      past = { "Memories of kindness, childhood, or simpler times surface. Those sweet moments still comfort you." },
      present = { "Nostalgia and gentle generosity are present. Reconnecting with something innocent or familiar may bring comfort." },
      future = { "A reunion, a kind gesture, or a return to something cherished may come. Warmth from the past can inform what is next." },
    },

    ["Seven of Cups"] = {
      past = { "Many dreams and options made it hard to choose. That fog of possibilities left its mark." },
      present = { "You face a lot of tempting options, and some of them are illusions. Ground your choices in what is real." },
      future = { "Choices may multiply. Clarity will come from separating wishful thinking from genuine opportunities." },
    },

    ["Eight of Cups"] = {
      past = { "You walked away from something that no longer fulfilled you. That decision still shapes you." },
      present = { "Something is no longer feeding you, and you may be ready to leave it. Moving on takes courage, even when it is quiet." },
      future = { "You may feel called to move on to something more meaningful. Leaving what no longer serves you can open a deeper search." },
    },

    ["Nine of Cups"] = {
      past = { "A wish was fulfilled and brought contentment. That satisfaction is part of your foundation." },
      present = { "There is reason to feel satisfied. Appreciate what you have and let yourself enjoy it." },
      future = { "Emotional fulfillment, or a wish coming true, may be near. Savoring what you have helps it last." },
    },

    ["Ten of Cups"] = {
      past = { "A sense of family harmony and emotional completeness once defined the situation. That ideal still guides you." },
      present = { "Love, harmony, and belonging are close. Cherish the people who matter and the peace you share." },
      future = { "Lasting happiness and emotional fulfillment may be on the way. Nurturing your closest relationships will help it grow." },
    },

    ["Page of Cups"] = {
      past = { "A tender message or a spark of imagination began this chapter. That openness was a gift." },
      present = { "A gentle invitation, a creative idea, or a vulnerable feeling is stirring. Meet it with openness and curiosity." },
      future = { "A heartfelt message, creative inspiration, or emotional beginning may arrive. Let yourself be a little playful." },
    },

    ["Knight of Cups"] = {
      past = { "A romantic or idealistic pursuit carried you forward. That quest shaped what you hope for." },
      present = { "Follow your heart, but check it against reality. An offer or invitation may be on the table." },
      future = { "A romantic or creative offer may come your way. Let your ideals guide you while keeping your feet on the ground." },
    },

    ["Queen of Cups"] = {
      past = { "Compassion, intuition, and emotional depth shaped how you handled this. That sensitivity was a strength." },
      present = { "Trust your feelings and extend compassion, including to yourself. Emotional wisdom is your guide." },
      future = { "Greater emotional depth and nurturing relationships may develop. Listening to your intuition will serve you." },
    },

    ["King of Cups"] = {
      past = { "Emotional maturity and calm diplomacy helped you through. That composure is part of how you got here." },
      present = { "Balance your head and your heart. Respond with calm, generous understanding rather than reacting." },
      future = { "Emotional mastery and steady compassion may guide you forward. Leading with kindness and balance will serve you." },
    },

    ---------------------------------------------------------------
    -- SWORDS (thoughts, communication, decisions, conflict)
    -- Three of Swords is near the top of this file.
    ---------------------------------------------------------------

    ["Ace of Swords"] = {
      past = { "A moment of clarity or a hard truth cut through confusion. That insight still shapes your thinking." },
      present = { "Clear thinking and honest communication are available. Cut to what is true and say it plainly." },
      future = { "A breakthrough idea or decisive truth may arrive. Use it with fairness and care." },
    },

    ["Two of Swords"] = {
      past = { "A difficult decision was left hanging in the balance, and avoiding it shaped the situation. The standoff left its mark." },
      present = { "You are at a stalemate and may be avoiding a choice. Take off the blindfold and look at what you already know." },
      future = { "A decision you have been postponing will probably need to be made. Gathering honest information will help." },
    },

    ["Four of Swords"] = {
      past = { "A period of rest or retreat helped you recover. That pause gave your mind space." },
      present = { "Rest and quiet reflection are important now. A deliberate pause can restore your clarity." },
      future = { "A time of recovery may be ahead. Stepping back to recharge will prepare you for what comes next." },
    },

    ["Five of Swords"] = {
      past = { "A conflict ended with a hollow win or a clear loss, and the tension lingered. The aftermath still affects how you relate." },
      present = { "Is winning this argument worth the cost? Consider whether the fight serves you, or whether it is time to walk away." },
      future = { "Conflict may come with costs on all sides. Choosing your battles carefully will protect your energy." },
    },

    ["Six of Swords"] = {
      past = { "You moved away from turbulence toward calmer waters. That transition set a gentler pace." },
      present = { "You are in transition, leaving something difficult behind. Calmer times are possible, though you may carry some baggage." },
      future = { "Smoother waters may lie ahead. Moving on thoughtfully can bring relief." },
    },

    ["Seven of Swords"] = {
      past = { "Secrecy, strategy, or a go-it-alone approach played a part. How you handled it still colors the situation." },
      present = { "Be mindful of honesty and strategy. Ask whether a sneaky approach serves you, or whether openness would work better." },
      future = { "Hidden motives or a clever plan may come into play. Being honest with yourself will keep you steady." },
    },

    ["Eight of Swords"] = {
      past = { "You felt trapped by your own thinking or circumstances. That sense of restriction taught you something." },
      present = { "You may feel stuck, but the bindings are looser than they look. Changing your perspective can show you a way out." },
      future = { "A sense of being stuck may ease as you recognize your options. The way out is likely through a shift in thinking." },
    },

    ["Nine of Swords"] = {
      past = { "Worry and sleepless nights weighed on you. Those anxieties shaped your outlook." },
      present = { "Anxiety may be louder at night than the facts justify. Name the worry and share it with someone you trust." },
      future = { "Stress may continue unless you address its source. Speaking about your fears will lighten them." },
    },

    ["Ten of Swords"] = {
      past = { "A painful ending or a low point was reached. That rock bottom has already passed, and you survived it." },
      present = { "Something has reached its end, and it hurts. The worst is behind you, and a new dawn is possible." },
      future = { "A difficult ending may come, but the way is clearing for a fresh start. Recovery follows even the hardest closing." },
    },

    ["Page of Swords"] = {
      past = { "Curiosity and questions pushed you to seek out the truth. That eager mind started this chapter." },
      present = { "Stay curious and alert. Ask questions, gather information, and communicate honestly." },
      future = { "New ideas or news may arrive. Approach them with a keen, open mind." },
    },

    ["Knight of Swords"] = {
      past = { "A rush of ideas or a hasty argument drove events. That speed left consequences." },
      present = { "Quick thinking is an asset, but guard against rushing or being blunt. Aim your words carefully." },
      future = { "Swift, decisive action in thought or speech may be needed. Think before you charge in." },
    },

    ["Queen of Swords"] = {
      past = { "Clear judgment and honest words shaped how you handled things. That candor earned respect." },
      present = { "Speak plainly and with perception. Boundaries and honesty serve you now." },
      future = { "Sharp insight and fair, independent judgment may guide you. Compassion can soften your honesty." },
    },

    ["King of Swords"] = {
      past = { "Reason, authority, and careful judgment shaped the course. That intellectual discipline still influences you." },
      present = { "Think logically and communicate with fairness. Your integrity and clarity carry weight." },
      future = { "Clear, principled decision-making may lead the way. Authority guided by fairness will earn trust." },
    },

    ---------------------------------------------------------------
    -- PENTACLES (work, resources, routines, material life)
    ---------------------------------------------------------------

    ["Ace of Pentacles"] = {
      past = { "A seed of opportunity or material security was planted. That early foothold still supports you." },
      present = { "A tangible opportunity is within reach. Plant it carefully and tend it with practical steps." },
      future = { "A new venture, resource, or sense of security may arrive. Prepare the ground so it can grow." },
    },

    ["Two of Pentacles"] = {
      past = { "You juggled competing demands and learned to adapt. That balancing act shaped your habits." },
      present = { "You are balancing multiple priorities. Stay flexible and keep your rhythm steady." },
      future = { "Changes in resources or responsibilities may call for adaptability. Keep a light touch and stay organized." },
    },

    ["Three of Pentacles"] = {
      past = { "Teamwork and skilled effort built something lasting. That collaboration is part of the foundation." },
      present = { "Working together and honing your craft pays off now. Seek feedback and respect other people's expertise." },
      future = { "Collaboration may bring recognition for good work. Building on solid skills will bring results." },
    },

    ["Four of Pentacles"] = {
      past = { "Holding tight to security and control gave you stability but also limits. That caution shaped your choices." },
      present = { "Be mindful of clinging to what you have. Security is good, but check that it has not become a cage." },
      future = { "A desire for stability may either protect or constrain you. Notice where you can loosen your grip." },
    },

    ["Five of Pentacles"] = {
      past = { "Hardship, lack, or feeling left out created difficulty. That experience still shapes your sense of security." },
      present = { "Times may feel lean, and help may be nearer than you think. Reaching out is not weakness." },
      future = { "Difficulty could continue until you ask for support. Help is available if you look for it." },
    },

    ["Six of Pentacles"] = {
      past = { "Generosity, given or received, balanced the scales. That exchange shaped your outlook on sharing." },
      present = { "Give and receive with fairness. Notice the flow of support, and do not be afraid to accept help." },
      future = { "A generous exchange or fair reward may arrive. Sharing what you have can create balance." },
    },

    ["Seven of Pentacles"] = {
      past = { "You invested effort and then had to wait. That patience taught you about growth." },
      present = { "Pause to assess your progress. The results of steady work take time, so evaluate before choosing your next step." },
      future = { "Patience will probably be rewarded, though results may be slow. Check whether your effort is going where you want it to." },
    },

    ["Eight of Pentacles"] = {
      past = { "Dedicated practice and attention to detail built your skill. That discipline is a lasting asset." },
      present = { "Diligent, focused effort is what is called for. Mastery comes from steady practice." },
      future = { "Continued hard work and refining your craft will likely pay off. Commitment to quality sets you apart." },
    },

    ["Nine of Pentacles"] = {
      past = { "Self-reliance and hard work brought comfort and independence. You earned what you have." },
      present = { "Enjoy the fruits of your effort. Your independence and refinement are well deserved." },
      future = { "Growing security and self-sufficiency may come. Savoring your achievements is part of the reward." },
    },

    ["Ten of Pentacles"] = {
      past = { "Lasting wealth, family, or legacy shaped the roots of this situation. That heritage still supports you." },
      present = { "Long-term security and family or community ties are in focus. Think about the legacy you want to build." },
      future = { "Lasting stability and a sense of legacy may come. Investing in the long term can bring enduring rewards." },
    },

    ["Page of Pentacles"] = {
      past = { "A new interest or course of study sparked a practical goal. That diligent curiosity began something real." },
      present = { "Approach a new goal with careful, patient steps. Learn by doing and stay grounded." },
      future = { "A new opportunity to learn or earn may appear. Take it seriously and build one step at a time." },
    },

    ["Knight of Pentacles"] = {
      past = { "Steady, methodical effort got you this far. That reliability earned trust." },
      present = { "Slow and steady is the way. Stay dependable and focus on the task at hand." },
      future = { "Persistent, careful work may carry you to your goal. Patience and routine will pay off." },
    },

    ["Queen of Pentacles"] = {
      past = { "Practical care, resourcefulness, and warmth made a stable home of this situation. That nurturing laid a foundation." },
      present = { "Create comfort and security through practical care. Look after your resources and your people." },
      future = { "Abundance and a sense of security may grow through your nurturing efforts. Generosity in practical ways will be rewarded." },
    },

    ["King of Pentacles"] = {
      past = { "Wise management of resources built stability. That prosperity is part of your foundation." },
      present = { "Lead with steadiness and practical wisdom. Manage resources well and build for the long term." },
      future = { "Material security and lasting success may be within reach. Prudent, generous stewardship will help it endure." },
    },

    -- Add your own cards below. Copy this template and fill it in:
    --
    -- ["The Magician"] = {
    --   past    = { "Text for the past position.", "A second version works too." },
    --   present = { "Text for the present position." },
    --   future  = { "Text for the possible-direction position." },
    --   any     = { "Used anywhere that has no list of its own." },
    -- },

  },
}
