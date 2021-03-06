import os
from datetime import datetime
from dateutil import tz



class HistLog:
    __DATETIME_FORMAT = "%a, %b %d %Y %I:%M%p"

    __LOCAL_TIMEZONE = tz.tzlocal()
    __PST_TIMEZONE = tz.gettz(
        "US/Alaska"
    )  # Alaska timezone, guards against Pacific Daylight Savings Time

    __RESET_HOUR = 0  # AM PST
    __MAX_HIST_LEN = 30  # days

    __COMPLETED_TRUE = "Successful"
    __COMPLETED_FALSE = "Failed {}"

    __EDGE_SEARCH_OPTION = "Edge Search"
    __WEB_SEARCH_OPTION = "Web Search"
    __MOBILE_SEARCH_OPTION = "Mobile Search"
    __OFFERS_OPTION = "Offers"

    def __init__(self, run_path, search_path, run_datetime=datetime.now()):
        self.run_path = run_path
        self.search_path = search_path
        self.__run_datetime = run_datetime.replace(tzinfo=self.__LOCAL_TIMEZONE)
        self.__run_hist = self.__read(run_path)
        self.__search_hist = self.__read(search_path)
        self.__completion = Completion()

    def __read(self, path):
        if not os.path.exists(path):
            return []
        else:
            with open(path, "r") as log:
                return [line.strip("\n") for line in log.readlines()]

    def get_timestamp(self):
        return self.__run_datetime.strftime(self.__DATETIME_FORMAT)
    def get_completion(self):
        # check if already ran today
        if len(self.__run_hist) > 0:
            print(self.__run_hist[-1].split(": "))
            last_ran, completed = self.__run_hist[-1].split(": ")

            last_ran_pst = datetime.strptime(last_ran, self.__DATETIME_FORMAT).replace(tzinfo=self.__LOCAL_TIMEZONE).astimezone(self.__PST_TIMEZONE)
            run_datetime_pst = self.__run_datetime.astimezone(
                self.__PST_TIMEZONE
            )
            delta_days = (run_datetime_pst.date() - last_ran_pst.date()).days
            is_already_ran_today = (
                (delta_days == 0 and last_ran_pst.hour >= self.__RESET_HOUR) or
                (delta_days == 1 and run_datetime_pst.hour < self.__RESET_HOUR)
            )
            if is_already_ran_today:
                if completed == self.__COMPLETED_TRUE:
                    self.__completion.edge_search = True
                    self.__completion.web_search = True
                    self.__completion.mobile_search = True
                    self.__completion.offers = True
                else:
                    if self.__EDGE_SEARCH_OPTION not in completed:
                        self.__completion.edge_search = True
                    if self.__WEB_SEARCH_OPTION not in completed:
                        self.__completion.web_search = True
                    if self.__MOBILE_SEARCH_OPTION not in completed:
                        self.__completion.mobile_search = True
                    if self.__OFFERS_OPTION not in completed:
                        self.__completion.offers = True
            else:
                self.__search_hist = []

        if not self.__completion.is_all_completed():
            # update hist with todays time stamp
            self.__run_hist.append(self.get_timestamp())
            if len(self.__run_hist) == self.__MAX_HIST_LEN:
                self.__run_hist = self.__run_hist[1:]

        return self.__completion
    def get_search_hist(self):
        return self.__search_hist
    def write(self, completion, search_hist):
        self.__completion.update(completion)
        if not self.__completion.is_all_completed():
            failed = []
            if not self.__completion.is_edge_search_completed():
                failed.append(self.__EDGE_SEARCH_OPTION)
            if not self.__completion.is_web_search_completed():
                failed.append(self.__WEB_SEARCH_OPTION)
            if not self.__completion.is_mobile_search_completed():
                failed.append(self.__MOBILE_SEARCH_OPTION)
            if not self.__completion.is_offers_completed():
                failed.append(self.__OFFERS_OPTION)
            failed = ', '.join(failed)
            msg = self.__COMPLETED_FALSE.format(failed)
        else:
            msg = self.__COMPLETED_TRUE

        if self.__COMPLETED_TRUE not in self.__run_hist[-1]:
            self.__run_hist[-1] = "{}: {}".format(self.__run_hist[-1], msg)

        with open(self.run_path, "w") as log:
            log.write("\n".join(self.__run_hist) + "\n")

        if search_hist:
            for query in search_hist:
                if query not in self.__search_hist:
                    self.__search_hist.append(query)
            #to avoid UnicodeEncodeErrors
            self.__search_hist = [
                hist.encode('ascii', 'ignore').decode('ascii')
                for hist in self.__search_hist
            ]
            with open(self.search_path, "w") as log:
                log.write("\n".join(self.__search_hist) + "\n")


class Completion:
    def __init__(self):
        self.edge_search = False
        self.web_search = False
        self.mobile_search = False
        self.offers = False

    def is_edge_search_completed(self):
        return self.edge_search
    def is_web_search_completed(self):
        return self.web_search
    def is_edge_and_web_search_completed(self):
        return self.web_search and self.edge_search
    def is_edge_and_mobile_search_completed(self):
        return self.mobile_search and self.edge_search
    def is_mobile_search_completed(self):
        return self.mobile_search
    def is_both_searches_completed(self):
        return self.is_edge_and_web_search_completed() and self.mobile_search
    def is_offers_completed(self):
        return self.offers
    def is_all_completed(self):
        return self.is_edge_and_web_search_completed(
        ) and self.mobile_search and self.offers

    def update(self, completion):
        self.edge_search = max(self.edge_search, completion.edge_search)
        self.web_search = max(self.web_search, completion.web_search)
        self.mobile_search = max(self.mobile_search, completion.mobile_search)
        self.offers = max(self.offers, completion.offers)
