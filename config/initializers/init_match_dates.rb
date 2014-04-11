

DAYS_IN_SEASON = 120
begin
  first_row = MatchDate.first
  now_date_id = MatchDate.id_by_current_date(MatchDate.current)

  if !first_row || !now_date_id || !MatchDate.exists?(now_date_id + DAYS_IN_SEASON-1)
    p 'INIT MATCH DATES'
    if !first_row
      p 'TABLE IS EMPTY'
      first_day = MatchDate.current
      1.upto(DAYS_IN_SEASON) do
        MatchDate.create(date: first_day)
        first_day = first_day + 1.day
      end
    elsif !now_date_id
      p 'TABLE IS EXISTS NOW DATE IS NOT PRESENT'
      last_day = MatchDate.cached_match_dates.last.date
      first_day = last_day + 1.day
      empty_days = ((Time.now - last_day)/86400).ceil
      1.upto(empty_days + DAYS_IN_SEASON) do
        MatchDate.create(date: first_day)
        first_day = first_day + 1.day
      end
    elsif !MatchDate.exists?(now_date_id + DAYS_IN_SEASON - 1)
      p 'TABLE IS EXISTS NOW DATE PRESENT'
      first_day = MatchDate.last.date + 1.day
      1.upto(DAYS_IN_SEASON) do
        MatchDate.create(date: first_day)
        first_day = first_day + 1.day
      end
    end
    MatchDate.reset_cache
    p 'END INIT MATCH DATES'
  end
rescue
  p 'ERROR WHEN INIT MATCH DATES'
end
