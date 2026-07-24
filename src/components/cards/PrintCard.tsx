import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";

import MainHeader from "@/components/headers/MainHeader";
import { Card, CardContent } from "@/components/ui/card";
import MainTitle from "@/components/titles/MainTitle";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { getIsReprint } from "@/utils/bootstrap/buildReprint";

type IProps = Readonly<{
  children: ReactNode;
}>;

const PrintCard = ({ children }: IProps) => {
  const { t } = useTranslation();
  const isReprint = getIsReprint();
  return (
    <section>
      {!isReprint && (
        <MainHeader description={t("header.descriptions.invoice")} />
      )}
      <div
        className={`mx-auto max-w-5xl flex justify-center ${isReprint ? "pt-0" : "pt-4"}`}
      >
        <Card
          className={`${isReprint ? "border-0 p-0" : "border-2 p-6 border-gray-100"} ring-0 w-full`}
        >
          <CardContent>
            <div className="flex flex-col">
              <MainTitle title={t("pages.invoice.title")} />
              <form
                id={buildComponentId("frm", "Print")}
                className="flex flex-col gap-5"
                autoComplete="off"
                onSubmit={(e) => e.preventDefault()}
              >
                {children}
              </form>
            </div>
          </CardContent>
        </Card>
      </div>
    </section>
  );
};

export default PrintCard;
