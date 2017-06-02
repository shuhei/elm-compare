module DateUtils exposing (addDays, subDays, relativeDate, formatDate)

import Date exposing (Date)


dayInMsecs : Float
dayInMsecs =
    24 * 60 * 60 * 1000


addDays : Int -> Date -> Date
addDays days date =
    Date.fromTime <| Date.toTime date + (toFloat days) * dayInMsecs


subDays : Int -> Date -> Date
subDays days =
    addDays -days


relativeDate : Date -> Date -> String
relativeDate today date =
    let
        diff =
            (Date.toTime date - Date.toTime today) / dayInMsecs
    in
        if diff > -1 && diff < 1 then
            "Today"
        else if diff > -2 && diff <= -1 then
            "Yesterday"
        else if diff >= 1 && diff < 2 then
            "Tomorrow"
        else
            formatDate date


formatDate : Date -> String
formatDate date =
    toString (Date.day date)
        ++ " "
        ++ toString (Date.month date)
        ++ ", "
        ++ toString (Date.year date)
